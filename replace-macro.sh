# stupid mac sed, I dont know how to match the end of word
# dont know how to match end of line and end of file
find . -name '*.tex' -exec sed -i '' "s/\\\\$1 /\\\\$2 /g" {} \; \
    -exec sed -i '' "s/\\\\$1}/\\\\$2}/g" {} \; \
    -exec sed -i '' "s/\\\\$1{/\\\\$2{/g" {} \; \
    -exec sed -i '' "s/\\\\$1)/\\\\$2)/g" {} \; \
    -exec sed -i '' "s/\\\\$1(/\\\\$2(/g" {} \; \
    -exec sed -i '' "s/\\\\$1_/\\\\$2_/g" {} \; \
    -exec sed -i '' "s/\\\\$1,/\\\\$2,/g" {} \; \
    -exec sed -i '' "s/\\\\$1'/\\\\$2'/g" {} \; \
    -exec sed -i '' "s/\\\\$1;/\\\\$2;/g" {} \; \
    -exec sed -i '' "s/\\\\$1;/\\\\$2;/g" {} \; \
    -exec sed -i '' "s/\\\\$1^/\\\\$2^/g" {} \; \
    -exec sed -i '' "s/\\\\$1\\./\\\\$2\\./g" {} \; \
    -exec sed -i '' "s/\\\\$1\\\\/\\\\$2\\\\/g" {} \; \
    -exec sed -i '' "s/\\\\$1\\$/\\\\$2\\$/g" {} \; \
    #-exec sed -i '' "s/\\\\$1\\r/\\\\$2\\r/g" {} \;
    #-exec sed -i '' "s/\\\\$1\\\>/\\\\$2\\\>/g" {} \; 
