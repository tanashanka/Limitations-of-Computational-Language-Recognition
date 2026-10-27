testWords = {'','a','aa','aaaa','aaaab','baaaaa','aaabaaaaa','aaaaaaaa'};

for i = 1:numel(testWords)
    state = 'Accept';
    for j = 1:strlength(testWords{i})
        if state == "Accept" && testWords{i}(j) == 'a'
            state = 'Accept';
        else
            state = 'Reject';
        end
    end
    fprintf('Word %s: %s\n',testWords{i},state)
end