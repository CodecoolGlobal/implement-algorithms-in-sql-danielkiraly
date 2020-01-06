-- SQL statements that are used to define the breadth-first search function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

CREATE OR REPLACE FUNCTION bfs(user_node INTEGER)
    RETURNS INTEGER AS
$$
DECLARE
    counter     integer;
    depth       integer;
    nodes       integer[];
    next        integer[];
    level       integer[];
    parent      integer[];
    parent_node integer;
    child_node  integer;
BEGIN
    depth := 1;
    counter := 0;
    nodes[0] := user_node;
    level[user_node] := 0;
    parent[user_node] = -1;
    WHILE nodes IS NOT NULL
        LOOP
            next := NULL;
            FOREACH parent_node IN ARRAY nodes
                LOOP
                    FOR child_node IN (SELECT node2
                                       FROM edges
                                       WHERE node1 = parent_node
                                       UNION ALL
                                       SELECT node1
                                       FROM edges
                                       WHERE node2 = parent_node)
                        LOOP
                            IF level[child_node] IS NULL THEN
                                parent[child_node] := parent_node;
                                level[child_node] := depth;
                                next = array_append(next, child_node);
                                depth := depth + 1;
                                counter := counter + 1;
                            END IF;
                        END LOOP;
                END LOOP;
            nodes := next;
        END LOOP;

    return counter;
END;
$$
    LANGUAGE PLPGSQL;