(define (problem wild-p3)
    (:domain wild)
    (:objects
		t1 t2 t3 t4 t5 t6 t7 t8 t9 - tile
    )
    (:init
		;; Start with an empty board and p1's turn
		(empty t1) (empty t2) (empty t3)
		(empty t4) (empty t5) (empty t6)
		(empty t7) (empty t8) (empty t9)
		(turn-p1)
		;; Misere version of the game, player who gets 3 in a row loses
		(misere)
    )
    (:goal
		;; Goal: p1 needs to win or at least draw
      	(and (terminal) (not (p2-win)))
    )
)