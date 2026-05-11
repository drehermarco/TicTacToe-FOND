(define (domain notakto)
    (:requirements :typing :conditional-effects :negative-preconditions)

    (:types tile)

    (:predicates
        ;; As the tile can only be empty or X, it is not necessary to have a seperate O predicate
        (x ?t - tile)
        (turn-p1)
        (turn-p2)
        (p1-win)
        (p2-win)
        (terminal)
        (check)
    )

    (:action p1-x
        :parameters (?t - tile)
        :precondition (and (not (x ?t)) (turn-p1) (not (terminal)) (not (check)))
        :effect
            (and
                (x ?t)
                (not (turn-p1))
                (turn-p2)
                (check)
            )
    )

    (:action p2-x
        :precondition (and (turn-p2) (not (terminal)) (not (check)))
        :effect
            (oneof
                (and (when (not (x t1)) (and (x t1) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t1) (and (terminal) (p1-win))))
                (and (when (not (x t2)) (and (x t2) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t2) (and (terminal) (p1-win))))
                (and (when (not (x t3)) (and (x t3) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t3) (and (terminal) (p1-win))))
                (and (when (not (x t4)) (and (x t4) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t4) (and (terminal) (p1-win))))
                (and (when (not (x t5)) (and (x t5) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t5) (and (terminal) (p1-win))))
                (and (when (not (x t6)) (and (x t6) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t6) (and (terminal) (p1-win))))
                (and (when (not (x t7)) (and (x t7) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t7) (and (terminal) (p1-win))))
                (and (when (not (x t8)) (and (x t8) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t8) (and (terminal) (p1-win))))
                (and (when (not (x t9)) (and (x t9) (not (turn-p2)) (turn-p1) (check)))
                    (when (x t9) (and (terminal) (p1-win)))) 
            )
    )

    ;; Check action after every move to see if anyone has 3 in a row
    (:action check-terminal
        :precondition (and (check) (not (terminal)))
        :effect
        (and
            ;; in Notakto, three in a row is a loss
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
                (and
                    ;; If it is "turn-p2" p1 just executed an action, so p1 loses
                    ;; If it is "turn-p1" p2 just executed an action, so p2 loses
                    (when (turn-p1) (and (terminal) (p1-win)))
                    (when (turn-p2) (and (terminal) (p2-win)))
                )
            )
            (not (check))
        )
    )
)