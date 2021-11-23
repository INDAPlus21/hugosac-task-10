% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).


% Top-level predicate
alive(Row, Column, BoardFileName):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen,                   % Closes the io-stream
    check_alive(Row, Column, Board).


% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
check_alive(Row, Column, Board):-
    % Check that there is a stone in the given position.
    nth1_2d(Row, Column, Board, Stone),
    (Stone = b; Stone = w),
    check_empty(Row, Column, Board, Stone, []).

% Check if a coordinate has already been visited
% by checking if a list contains the coordinate.
already_checked(Coord, [H | T]) :-
    Coord = H ; already_checked(Coord, T).

% Recursively checks through adjacent pieces in a group to
% try to find an empty position. 
check_empty(Row, Column, Board, Stone, CheckedList) :-
    
    % Get the stone color from the coordinate of the current stone.
    nth1_2d(Row, Column, Board, CurrentStone),

    % The current position is empty
    (CurrentStone = e ; 
        % Current stone has the same color as the group to search through.
        (CurrentStone = Stone, 
            % Coordinate has not been visited already.
            \+ already_checked((Row, Column), CheckedList), 

            % All four directions
            RowUp is Row + 1,
            RowDown is Row - 1,
            ColLeft is Column - 1,
            ColRight is Column + 1,
            (
                % Recursively check adjacent positions. Append the checked postions to
                % the CheckedList.
                check_empty(RowUp, Column, Board, Stone, [(Row, Column) | CheckedList]);
                check_empty(RowDown, Column, Board, Stone, [(Row, Column) | CheckedList]);
                check_empty(Row, ColLeft, Board, Stone, [(Row, Column) | CheckedList]);
                check_empty(Row, ColRight, Board, Stone, [(Row, Column) | CheckedList])
            )
        )
    ).

