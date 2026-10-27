for n = 1:8
    binaryStrings = dec2bin(0:2^n-1,n);
    
    binaryStrings(binaryStrings == '0') = 'a';
    binaryStrings(binaryStrings == '1') = 'b';
    
    acceptedCount = 0;
    
    for i = 1:size(binaryStrings,1)
        result = isInLanguage(binaryStrings(i,:));
        if result
            acceptedCount = acceptedCount + 1;
        end
    end
    
    fprintf('Number of accepted strings at length %d: %d\n', n, acceptedCount);
end