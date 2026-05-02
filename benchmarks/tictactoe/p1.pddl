(define (problem ttt-p1)
    (:domain tictactoe)
    (:objects
      r1 r2 r3 - row
      c1 c2 c3 - col
    )
    (:init
      (empty r1 c1) (empty r1 c2) (empty r1 c3)
      (empty r2 c1) (empty r2 c2) (empty r2 c3)
      (empty r3 c1) (empty r3 c2) (empty r3 c3)
      (turn-x)
    )
    (:goal
      (and (terminal) (not (o-win)))
    )
)