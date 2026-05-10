(define (problem ttt-p3)
    (:domain tictactoe)
    (:objects
		t1 t2 t3 t4 t5 t6 t7 t8 t9 - tile
    )
    (:init
		;; Start with an empty board and O's turn
		(empty t1) (empty t2) (empty t3)
		(empty t4) (empty t5) (empty t6)
		(empty t7) (empty t8) (empty t9)
		(turn-o)
    )
    (:goal
		;; Goal: X needs to win
      	(and (x-win))
    )
)