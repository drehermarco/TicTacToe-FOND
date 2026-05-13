(define (domain wild)
    (:requirements :typing :conditional-effects :negative-preconditions)

    (:types tile)

    (:predicates
        (empty ?t - tile)
        (x ?t - tile)
        (o ?t - tile)
        (turn-p1)
        (turn-p2)
        (p1-win)
        (p2-win)
        (draw)
        (terminal)
        (check)
        ;; Here we use a predicate for the misere version
        ;; Just reversing the goal leads to bad policies hence we model a
        ;; misere check-terminal action
        (misere)
    )

    ;; X can place an X into any empty tile
    (:action place-x
        :parameters (?t - tile)
        :precondition (and (empty ?t) (turn-p1) (not (terminal)) (not (check)))
        :effect
        (and
            (not (empty ?t))
            (x ?t)
            (not (turn-p1))
            (turn-p2)
            (check)
        )
    )

    ;; p1 can also place an O into any empty tile
    (:action place-o
        :parameters (?t - tile)
        :precondition (and (empty ?t) (turn-p1) (not (terminal)) (not (check)))
        :effect
        (and
            (not (empty ?t))
            (o ?t)
            (not (turn-p1))
            (turn-p2)
            (check)
        )
    )

    ;; p2 places either an X or O into any tile non-deterministically via oneof clause
    (:action p2-place
        :precondition (and (turn-p2) (not (terminal)) (not (check)))
        :effect
        (oneof
            (and (when (empty t1) (and (not (empty t1)) (o t1) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t1)) (and (terminal) (p1-win))))
            (and (when (empty t2) (and (not (empty t2)) (o t2) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t2)) (and (terminal) (p1-win))))
            (and (when (empty t3) (and (not (empty t3)) (o t3) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t3)) (and (terminal) (p1-win))))
            (and (when (empty t4) (and (not (empty t4)) (o t4) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t4)) (and (terminal) (p1-win))))
            (and (when (empty t5) (and (not (empty t5)) (o t5) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t5)) (and (terminal) (p1-win))))
            (and (when (empty t6) (and (not (empty t6)) (o t6) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t6)) (and (terminal) (p1-win))))
            (and (when (empty t7) (and (not (empty t7)) (o t7) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t7)) (and (terminal) (p1-win))))
            (and (when (empty t8) (and (not (empty t8)) (o t8) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t8)) (and (terminal) (p1-win))))
            (and (when (empty t9) (and (not (empty t9)) (o t9) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t9)) (and (terminal) (p1-win))))
            (and (when (empty t1) (and (not (empty t1)) (x t1) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t1)) (and (terminal) (p1-win))))
            (and (when (empty t2) (and (not (empty t2)) (x t2) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t2)) (and (terminal) (p1-win))))
            (and (when (empty t3) (and (not (empty t3)) (x t3) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t3)) (and (terminal) (p1-win))))
            (and (when (empty t4) (and (not (empty t4)) (x t4) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t4)) (and (terminal) (p1-win))))
            (and (when (empty t5) (and (not (empty t5)) (x t5) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t5)) (and (terminal) (p1-win))))
            (and (when (empty t6) (and (not (empty t6)) (x t6) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t6)) (and (terminal) (p1-win))))
            (and (when (empty t7) (and (not (empty t7)) (x t7) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t7)) (and (terminal) (p1-win))))
            (and (when (empty t8) (and (not (empty t8)) (x t8) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t8)) (and (terminal) (p1-win))))
            (and (when (empty t9) (and (not (empty t9)) (x t9) (not (turn-p2)) (turn-p1) (check)))
                (when (not (empty t9)) (and (terminal) (p1-win))))
        )
    )


    (:action check-terminal
        :precondition (and (not (misere)) (check) (not (terminal)))
        :effect
        (and
            ;; p1 just moved, so when there are any three in a row -> win
            (when
                (and
                    (or
                        (and (x t1) (x t2) (x t3))
                        (and (x t4) (x t5) (x t6))
                        (and (x t7) (x t8) (x t9))
                        (and (x t1) (x t4) (x t7))
                        (and (x t2) (x t5) (x t8))
                        (and (x t3) (x t6) (x t9))
                        (and (x t1) (x t5) (x t9))
                        (and (x t3) (x t5) (x t7))
                        (and (o t1) (o t2) (o t3))
                        (and (o t4) (o t5) (o t6))
                        (and (o t7) (o t8) (o t9))
                        (and (o t1) (o t4) (o t7))
                        (and (o t2) (o t5) (o t8))
                        (and (o t3) (o t6) (o t9))
                        (and (o t1) (o t5) (o t9))
                        (and (o t3) (o t5) (o t7))
                    )
                    (not (turn-p1))
                )
                (and (p1-win) (terminal))
            )
            ;; same for p2
            (when
                (and
                    (or
                        (and (x t1) (x t2) (x t3))
                        (and (x t4) (x t5) (x t6))
                        (and (x t7) (x t8) (x t9))
                        (and (x t1) (x t4) (x t7))
                        (and (x t2) (x t5) (x t8))
                        (and (x t3) (x t6) (x t9))
                        (and (x t1) (x t5) (x t9))
                        (and (x t3) (x t5) (x t7))
                        (and (o t1) (o t2) (o t3))
                        (and (o t4) (o t5) (o t6))
                        (and (o t7) (o t8) (o t9))
                        (and (o t1) (o t4) (o t7))
                        (and (o t2) (o t5) (o t8))
                        (and (o t3) (o t6) (o t9))
                        (and (o t1) (o t5) (o t9))
                        (and (o t3) (o t5) (o t7))
                    )
                    (not (turn-p2))
                )
                (and (p2-win) (terminal))
            )
            ;; draw
            (when
                (and
                    (not (p1-win))
                    (not (p2-win))
                    (not (empty t1)) (not (empty t2)) (not (empty t3))
                    (not (empty t4)) (not (empty t5)) (not (empty t6))
                    (not (empty t7)) (not (empty t8)) (not (empty t9))
                )
                (and (draw) (terminal))
            )
            (not (check))
        )
    )

    (:action check-terminal-misere
        :precondition (and (misere) (check) (not (terminal)))
        :effect
        (and
            ;; p1 just moved, so when there are any three in a row -> lose
            (when
                (and
                    (or
                        (and (x t1) (x t2) (x t3))
                        (and (x t4) (x t5) (x t6))
                        (and (x t7) (x t8) (x t9))
                        (and (x t1) (x t4) (x t7))
                        (and (x t2) (x t5) (x t8))
                        (and (x t3) (x t6) (x t9))
                        (and (x t1) (x t5) (x t9))
                        (and (x t3) (x t5) (x t7))
                        (and (o t1) (o t2) (o t3))
                        (and (o t4) (o t5) (o t6))
                        (and (o t7) (o t8) (o t9))
                        (and (o t1) (o t4) (o t7))
                        (and (o t2) (o t5) (o t8))
                        (and (o t3) (o t6) (o t9))
                        (and (o t1) (o t5) (o t9))
                        (and (o t3) (o t5) (o t7))
                    )
                    (not (turn-p1))
                )
                (and (p2-win) (terminal))
            )
            ;; same for p2
            (when
                (and
                    (or
                        (and (x t1) (x t2) (x t3))
                        (and (x t4) (x t5) (x t6))
                        (and (x t7) (x t8) (x t9))
                        (and (x t1) (x t4) (x t7))
                        (and (x t2) (x t5) (x t8))
                        (and (x t3) (x t6) (x t9))
                        (and (x t1) (x t5) (x t9))
                        (and (x t3) (x t5) (x t7))
                        (and (o t1) (o t2) (o t3))
                        (and (o t4) (o t5) (o t6))
                        (and (o t7) (o t8) (o t9))
                        (and (o t1) (o t4) (o t7))
                        (and (o t2) (o t5) (o t8))
                        (and (o t3) (o t6) (o t9))
                        (and (o t1) (o t5) (o t9))
                        (and (o t3) (o t5) (o t7))
                    )
                    (not (turn-p2))
                )
                (and (p1-win) (terminal))
            )
            ;; draw
            (when
                (and
                    (not (p1-win))
                    (not (p2-win))
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