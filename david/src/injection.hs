import Data.List as List
import Data.HashMap.Strict as Map

-- Program variable names.
type Var  = String

-- Storage cells' keys.
type Key  = Int

-- Storage cells' values.
type Val  = Int

-- Locking modes.
data Mode = U -- Unlocked
          | S -- Shared
          | X -- Exclusive
          deriving (Eq, Ord, Show)

-- Commands.
data Cmd  = Skip
          | Assign Var Val
          | Read Var Key
          | Write Key Val
          | Seq Cmd Cmd
          | Cond Bool Cmd Cmd
          | Loop Bool Cmd
          deriving Show

-- Locked commands.
data LCmd = LSkip
          | LAssign Var Val
          | LRead Var Key
          | LWrite Key Val
          | LSeq LCmd LCmd
          | LCond Bool LCmd LCmd
          | LLoop Bool LCmd
          | Lock Key Mode
          | Unlock Key

instance Show LCmd where
  -- Pretty print programs.
  show LSkip
    = "skip"
  show (LAssign x v)
    = (show x) ++ " = " ++ (show v)
  show (LRead x k)
    = (show x) ++ " = [" ++ (show k) ++ "]"
  show (LWrite k v)
    = "[" ++ (show k) ++ "] = " ++ (show v)
  show (LSeq c1 c2)
    = (show c1) ++ "; " ++ (show c2)
  show (LCond b c1 c2)
    = "if (" ++ (show b) ++ ") then " ++ (show c1) ++ " else " ++ (show c2)
  show (LLoop b c)
    = "while (" ++ (show b) ++ ") " ++ (show c)
  show (Lock k mode)
    = "lock(" ++ (show k) ++ ", " ++ (show mode) ++ ")"
  show (Unlock k)
    = "unlock(" ++ (show k) ++ ")"


inject :: Cmd -> LCmd
inject c
  = LSkip

scanLocks c
  = Prelude.map (\(k, mode) -> (Lock k mode)) (toList m)
  where m = scanAccesses c empty

scanAccesses (Read _ k) m
  = modeInsert k S m

scanAccesses (Write k _) m
  = modeInsert k X m

scanAccesses (Seq c1 c2) m
  = m2
  where m1 = scanAccesses c1 m
        m2 = scanAccesses c2 m1

scanAccesses (Cond _ c1 c2) m
  = m2
  where m1 = scanAccesses c1 m
        m2 = scanAccesses c2 m1

scanAccesses (Loop _ c) m
  = scanAccesses c m

scanAccesses _ m
  = m

modeInsert k mode m
  = if mode > curr then (insert k mode m) else m
  where entry = Map.lookup k m
        curr  = case entry of
                  Just mo -> mo
                  Nothing -> U

injectLocks c trans []
  = [LSeq trans c]

injectLocks c trans (l:ls)
  = (LSeq trans (LSeq l c)):(injectLocks c (LSeq trans l) ls)++(injectLocks c trans ls)

injectUnlocks (LRead x k) m phase
  = case entry of
      Nothing -> (LRead x k, m, phase)
      Just _  -> (cmd, delete k m, phase)
  where entry = Map.lookup k m
        cmd   = if phase -- Still in the growing phase so don't unlock.
                then (LRead x k)
                else (LSeq (LRead x k) (Unlock k))

injectUnlocks (LWrite k v) m phase
  = case entry of
      Nothing -> (LWrite k v, m, phase)
      Just _  -> (cmd, delete k m, phase)
      where entry = Map.lookup k m
            cmd   = if phase
                    then (LWrite k v)
                    else (LSeq (LWrite k v) (Unlock k))

injectUnlocks (Lock k mode) m phase
  = (LSeq (Lock k mode) us, empty, True)
  where us = unlockResiduals (keys m)

injectUnlocks (LSeq c1 c2) m phase
  = (LSeq k1 k2, m1, phase1)
  where (k2, m2, phase2) = injectUnlocks c2 m phase
        (k1, m1, phase1) = injectUnlocks c1 m2 phase2

injectUnlocks c m phase
  = (c, m, phase)


unlockResiduals
  = Prelude.foldr (\k c -> (LSeq (Unlock k) c)) LSkip
