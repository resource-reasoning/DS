import Data.HashMap.Strict

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
--
-- Here, ``Lseq [LCmd]'' is a better idea SHALE :)
--
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
  = u
  where (l, m) = injectLocks c empty
        (u, _, _) = injectUnlocks l m False


injectLocks Skip m
  = (LSkip, m)

injectLocks (Assign x v) m
  = (LAssign x v, m)

injectLocks (Read x k) m
  = case entry of
      Nothing -> (LSeq (Lock k S) (LRead x k), insert k S m)
      Just _  -> (LRead x k, m)
  where entry = Data.HashMap.Strict.lookup k m

injectLocks (Write k v) m
  = case entry of
      Just X -> (LWrite k v, m)
      _      -> (LSeq (Lock k X) (LWrite k v), insert k X m)
  where entry = Data.HashMap.Strict.lookup k m

injectLocks (Seq c1 c2) m
  = (LSeq k1 k2, m2)
  where (k1, m1) = injectLocks c1 m
        (k2, m2) = injectLocks c2 m1

injectLocks (Cond b c1 c2) m
  = (LCond b k1 k2, union m1 m2)
  where (k1, m1) = injectLocks c1 m
        (k2, m2) = injectLocks c2 m

injectLocks (Loop b c) m
  = (LLoop b k, mUp)
  where (k, mUp) = injectLocks c m


injectUnlocks (LRead x k) m phase
  = case entry of
      Nothing -> (LRead x k, m, phase)
      --
      -- Here it looks like cmd might not include Unlock.
      -- but ``delete k m'' is still called SHALE
      --
      Just _  -> (cmd, delete k m, phase)
  where entry = Data.HashMap.Strict.lookup k m
        cmd   = if phase -- Still in the growing phase so don't unlock.
                then (LRead x k)
                else (LSeq (LRead x k) (Unlock k))

injectUnlocks (LWrite k v) m phase
  = case entry of
      Nothing -> (LWrite k v, m, phase)
      Just _  -> (cmd, delete k m, phase)
      where entry = Data.HashMap.Strict.lookup k m
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
