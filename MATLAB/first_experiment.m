strings = {'','ab','aabb','abb','ba','aaabbb','abab'};
for i = 1:numel(strings)

    a_count = 0;
    b_count = 0;
    is_invalid = false;

    for j = 1:strlength(strings{i})

        if strings{i}(j) == 'a'
            a_count = a_count + 1;
        elseif strings{i}(j) == 'b'
            b_count = b_count + 1;
        end
        if (j > 1 && strings{i}(j) == 'a' && strings{i}(j - 1) == 'b')
            is_invalid = true;
        end

    end

    if is_invalid || a_count ~= b_count
        fprintf('Invalid string: %s\n', strings{i})
    else
        fprintf('Valid: a count = %d, b count = %d\n', a_count, b_count)
    end

end