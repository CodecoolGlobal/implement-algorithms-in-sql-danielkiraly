-- SQL statements that are used to define the Levenshtein distance function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

CREATE OR REPLACE FUNCTION levenshtein(input_word_1 text, input_word_2 text)
    RETURNS integer AS
$$
DECLARE
    i        integer;
    j        integer;
    length_1 integer;
    length_2 integer;
    distance integer[];
    cost     integer;

BEGIN
    length_1 := char_length(input_word_1);
    length_2 := char_length(input_word_2);

    i := 0;
    j := 0;

    FOR i IN 0..length_1
        LOOP
            distance[i * (length_2 + 1)] = i;
        END LOOP;

    FOR j IN 0..length_2
        LOOP
            distance[j] = j;
        END LOOP;

    FOR i IN 1..length_1
        LOOP
            FOR j IN 1..length_2
                LOOP
                    IF SUBSTRING(input_word_1, i, 1) = SUBSTRING(input_word_2, j, 1) THEN
                        cost := 0;
                    ELSE
                        cost := 1;
                    END IF;
                    distance[i * (length_2 + 1) + j] := LEAST(distance[(i - 1) * (length_2 + 1) + j] + 1,
                                                              distance[i * (length_2 + 1) + j - 1] + 1,
                                                              distance[(i - 1) * (length_2 + 1) + j - 1] + cost);
                END LOOP;
        END LOOP;

    return distance[length_1 * (length_2 + 1) + length_2];
END;
$$ LANGUAGE plpgsql;