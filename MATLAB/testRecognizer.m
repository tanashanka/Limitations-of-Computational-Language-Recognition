testWords = {'','ab','aabb','abb','ba','aaabbb','abab','aaabb','bbaa','aabbb','abc','a','b','bbbb'};

for i = 1:numel(testWords)
    result = isInLanguage(testWords{i});
    fprintf('string: %s; result: %s\n',testWords{i},string(result))
end