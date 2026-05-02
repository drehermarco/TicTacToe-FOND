(define (domain tictactoe)
    (:requirements :typing :conditional-effects :negative-preconditions :derived-predicates)

    (:types row col)

    (:predicates
        (empty ?r - row ?c - col)
        (x ?r - row ?c - col)
        (o ?r - row ?c - col)
        (turn-x)
        (turn-o)
    )

    (:action place-x
        :parameters (?r - row ?c - col)
        :precondition (and (empty ?r ?c) (turn-x) (not (terminal)))
        :effect
        (and
            (not (empty ?r ?c))
            (x ?r ?c)
            (not (turn-x))
            (turn-o)
        )
    )

    (:action place-o
        :precondition (and (turn-o) (not (terminal)))
        :effect
        (and
            (oneof
            (when (empty r1 c1)
                (and (not (empty r1 c1)) (o r1 c1) (not (turn-o)) (turn-x)))
            (when (empty r1 c2)
                (and (not (empty r1 c2)) (o r1 c2) (not (turn-o)) (turn-x)))
            (when (empty r1 c3)
                (and (not (empty r1 c3)) (o r1 c3) (not (turn-o)) (turn-x)))
            (when (empty r2 c1)
                (and (not (empty r2 c1)) (o r2 c1) (not (turn-o)) (turn-x)))
            (when (empty r2 c2)
                (and (not (empty r2 c2)) (o r2 c2) (not (turn-o)) (turn-x)))
            (when (empty r2 c3)
                (and (not (empty r2 c3)) (o r2 c3) (not (turn-o)) (turn-x)))
            (when (empty r3 c1)
                (and (not (empty r3 c1)) (o r3 c1) (not (turn-o)) (turn-x)))
            (when (empty r3 c2)
                (and (not (empty r3 c2)) (o r3 c2) (not (turn-o)) (turn-x)))
            (when (empty r3 c3)
                (and (not (empty r3 c3)) (o r3 c3) (not (turn-o)) (turn-x)))
            )
        )
    )

    (:action check-terminal
        :precondition (not (terminal))
        :effect
        (and
            ;; X win
            (when
                (or
                (and (x r1 c1) (x r1 c2) (x r1 c3))
                (and (x r2 c1) (x r2 c2) (x r2 c3))
                (and (x r3 c1) (x r3 c2) (x r3 c3))
                (and (x r1 c1) (x r2 c1) (x r3 c1))
                (and (x r1 c2) (x r2 c2) (x r3 c2))
                (and (x r1 c3) (x r2 c3) (x r3 c3))
                (and (x r1 c1) (x r2 c2) (x r3 c3))
                (and (x r1 c3) (x r2 c2) (x r3 c1))
                )
                (and (x-win) (terminal))
            )
            ;; O win
            (when
                (or
                (and (o r1 c1) (o r1 c2) (o r1 c3))
                (and (o r2 c1) (o r2 c2) (o r2 c3))
                (and (o r3 c1) (o r3 c2) (o r3 c3))
                (and (o r1 c1) (o r2 c1) (o r3 c1))
                (and (o r1 c2) (o r2 c2) (o r3 c2))
                (and (o r1 c3) (o r2 c3) (o r3 c3))
                (and (o r1 c1) (o r2 c2) (o r3 c3))
                (and (o r1 c3) (o r2 c2) (o r3 c1))
                )
                (and (o-win) (terminal))
            )
            ;; draw
            (when
                (and
                (not (x-win))
                (not (o-win))
                (not (empty r1 c1)) (not (empty r1 c2)) (not (empty r1 c3))
                (not (empty r2 c1)) (not (empty r2 c2)) (not (empty r2 c3))
                (not (empty r3 c1)) (not (empty r3 c2)) (not (empty r3 c3))
                )
                (and (draw) (terminal))
            )
        )
    )
)