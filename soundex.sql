-- SQL statements that are used to define the soundex function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

CREATE OR REPLACE FUNCTION soundex(input text)
    RETURNS text AS
$$
DECLARE
    soundex     text = '';
    char        text;
    symbol      text;
    last_symbol text = '';
    pos         INT  = 1;
BEGIN
    WHILE LENGTH(soundex) < 4
        LOOP
            char = UPPER(substr(input, pos, 1));
            pos = pos + 1;
            CASE char
                WHEN '' THEN RETURN '';
                WHEN 'B', 'F', 'P', 'V' THEN symbol = '1';
                WHEN 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' THEN symbol = '2';
                WHEN 'D', 'T' THEN symbol = '3';
                WHEN 'L' THEN symbol = '4';
                WHEN 'M', 'N' THEN symbol = '5';
                WHEN 'R' THEN symbol = '6';
                ELSE symbol = '';
                END CASE;

            IF soundex = '' THEN
                soundex = char;
                last_symbol = symbol;
            ELSIF last_symbol != symbol THEN
                soundex = soundex || symbol;
                last_symbol = symbol;
            END IF;
        END LOOP;

    RETURN soundex;
END;
$$ LANGUAGE plpgsql;