(define (domain misere)
    (:requirements :typing :conditional-effects :negative-preconditions)

    (:types tile)

    (:predicates
        (empty ?t - tile)
        (x ?t - tile)
        (o ?t - tile)
        (turn-x)
        (turn-o)
        (x-win)
        (o-win)
        (draw)
        (terminal)
        (check)
    )

    ;; X can place an X into any empty tile
    (:action place-x
        :parameters (?t - tile)
        :precondition (and (empty ?t) (turn-x) (not (terminal)) (not (check)))
        :effect
        (and
            (not (empty ?t))
            (x ?t)
            (not (turn-x))
            (turn-o)
            (check)
        )
    )

    ;; O places an O into any tile via oneof clause -> one of the tiles is chosen nondeterministically
    ;; Additionally, if the chosen tile is not empty, X wins as the move is invalid (credit to Prof Helmert for the idea)
    (:action place-o
        :precondition (and (turn-o) (not (terminal)) (not (check)))
        :effect
        (oneof
            (and (when (empty t1) (and (not (empty t1)) (o t1) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t1)) (and (terminal) (x-win))))
            (and (when (empty t2) (and (not (empty t2)) (o t2) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t2)) (and (terminal) (x-win))))
            (and (when (empty t3) (and (not (empty t3)) (o t3) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t3)) (and (terminal) (x-win))))
            (and (when (empty t4) (and (not (empty t4)) (o t4) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t4)) (and (terminal) (x-win))))
            (and (when (empty t5) (and (not (empty t5)) (o t5) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t5)) (and (terminal) (x-win))))
            (and (when (empty t6) (and (not (empty t6)) (o t6) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t6)) (and (terminal) (x-win))))
            (and (when (empty t7) (and (not (empty t7)) (o t7) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t7)) (and (terminal) (x-win))))
            (and (when (empty t8) (and (not (empty t8)) (o t8) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t8)) (and (terminal) (x-win))))
            (and (when (empty t9) (and (not (empty t9)) (o t9) (not (turn-o)) (turn-x) (check)))
                (when (not (empty t9)) (and (terminal) (x-win))))
        )
    )

    ;; In misere tic-tac-toe, the first player to get three in a row loses, so the terminal check is different
    ;; This is the only thing that changes in comparison to the standard tic-tac-toe domain
    (:action check-terminal
        :precondition (and (check) (not (terminal)))
        :effect
        (and
            ;; O win
            (when
                (or
                    (and (x t1) (x t2) (x t3))
                    (and (x t4) (x t5) (x t6))
                    (and (x t7) (x t8) (x t9))
                    (and (x t1) (x t4) (x t7))
                    (and (x t2) (x t5) (x t8))
                    (and (x t3) (x t6) (x t9))
                    (and (x t1) (x t5) (x t9))
                    (and (x t3) (x t5) (x t7))
                )
                (and (o-win) (terminal))
            )
            ;; X win
            (when
                (or
                    (and (o t1) (o t2) (o t3))
                    (and (o t4) (o t5) (o t6))
                    (and (o t7) (o t8) (o t9))
                    (and (o t1) (o t4) (o t7))
                    (and (o t2) (o t5) (o t8))
                    (and (o t3) (o t6) (o t9))
                    (and (o t1) (o t5) (o t9))
                    (and (o t3) (o t5) (o t7))
                )
                (and (x-win) (terminal))
            )
            ;; draw
            (when
                (and
                    (not (x-win))
                    (not (o-win))
                    (not (empty t1)) (not (empty t2)) (not (empty t3))
                    (not (empty t4)) (not (empty t5)) (not (empty t6))
                    (not (empty t7)) (not (empty t8)) (not (empty t9))
                )
                (and (draw) (terminal))
            )
            (not (check))
        )
    )
)