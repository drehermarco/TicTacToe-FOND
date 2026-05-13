(define (problem misere-p1)
    (:domain misere)
    (:objects
		t1 t2 t3 t4 t5 t6 t7 t8 t9 - tile
    )
    (:init
		;; Start with an empty board and X's turn
		(empty t1) (empty t2) (empty t3)
		(empty t4) (empty t5) (empty t6)
		(empty t7) (empty t8) (empty t9)
		(turn-x)
    )
    (:goal
		;; Goal: X needs to win or at least draw
      	(and (terminal) (not (o-win)))
    )
)