function result = isInLanguage(string)
    
    a_count = 0;
    b_count = 0;
    is_invalid = false;

    for i = 1:strlength(string)
        if string(i) == 'a'
            a_count = a_count + 1;
        elseif string(i) == 'b'
            b_count = b_count + 1;
        else
            is_invalid = true;
        end
        if (i > 1 && string(i) == 'a' && string(i - 1) == 'b')
            is_invalid = true;
        end
    end
    if is_invalid || a_count ~= b_count
        result = false;
    else
        result = true;
    end

end