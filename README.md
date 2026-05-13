# TicTacToe in Fully Observable Non-Deterministic Planning 

## Repository Structure
- benchmarks: contains all PDDL files that encode the corresponding variant. Each problem has a domain file and multiple problem files, that encode different inital state or goal states. For standard TicTacToe there are two domains, where "domain_noop" models the non-deterministic player with no-ops when invalid moves are chosen. This way is tries to place an "O" until it finds a valid moves, which induces self loops that eventually lead to Strong Cyclic Plans instead of Strong Plans.
- policies: contains all resulting policies when solving the PDDL files with PRP. These files are already in "human readable" form by executing the given "translate_policy.py" script.
- policy_simulation.py: this script takes the policy files and simulates the game instances with a simple UI. 

## Which domains are contained?
### TicTacToe
This is the standard variant of TicTacToe with two players (X and O). The goal is to get three in a row (either top to bottom, left to right or diagonally).

### Misere TicTacToe
Misere TicTacToe flips the goal condition. This means that if any player gets three in a row, they lose the game.

### Notakto
Notakto takes Misere a step further by only allowing one symbol. This means that both players have the same symbol (for example X) and if any player completes three in a row they lose.

### Wild TicTacToe
In Wild TicTacToe the players also have the choice of which symbol they place (either X or O). This can be played as either standard rules (get three in a row) or with misere rules (get three in a row -> you lose).


## How to generate policies
We used the planner for relevant policies (PRP) by Muise et al. in order to generate the polcies. Step 1 to Step 3 show how we aquired the policies that can be found in the policies folder, so if you are only interested in running the simulation you can use the files contained in there.

### 1. Setting up PRP
To setup PRP you can follow the guide on their Github: https://github.com/QuMuLab/planner-for-relevant-policies.git

### 2. Run PRP 
In order to generate the policies from the PDDL files run the following command:
```bash
./src/prp <domain> <problem> --dump-policy 2
```

### 3. Convert the aquired file into a human readable form
The resulting file is hard to understand, hence we run a script that converts it into a somewhat human readable form:
```bash
python prp-scripts/translate_policy.py > human_policy.pol
```


### 4. Simulating the policy
The policy_simulation.py script then takes the human readable policy and runs a very simple UI to demonstrate the aquired policy. This script requires the streamlit python library.
```bash
pip install streamlit
```

```bash
streamlit run policy_simulation.py
```


## Per-Problem Results Table

In this section we list the different execution statistics for the domains. We list time to solve and what type of policy was aquired.

Quick note: the goals for each problem file are inside of the parantheses. These are always from the deterministic agents perspective. For example, "do not lose" simply means our agent X is not allowed to lose. 

### Policy Types ###
 - Weak Plan, which means that the resulting policy can solve some states of the problem, but is not guaranteed to solve all of them.
 - Strong Cyclic Plan, which means that the resulting policy can solve all states of the problem.

TicTacToe (atleast the way it is modeled here) does not contain cycles, hence it should technically be Strong Plans instead of Strong Cyclic Plans (the only domain that contains cycles is the "domain_noop.pddl" inside the standard tictactoe benchmark, hence the resulting policy would be cyclic). The reason it is referred to as Strong Cyclic Plan here is that PRP does not return Strong Plans per se.


### Standard TicTacToe

| Problem file | Time to solve (s) | Policy type |
|---|---:|---|
| p1 (do not lose, x starts) | 31.44s | Strong (Cyclic) Policy |
| p2 (do not lose, o starts) | 1141.23s | Strong (Cyclic) Policy |
| p3 (win, x starts) | 882.55s | Weak Plan |
| p4 (win, o starts) | 422.49s | Weak Plan |

### Misere TicTacToe

| Problem file | Time to solve (s) | Policy type |
|---|---:|---|
| p1 (do not lose, x starts) | 284.32s | Strong (Cyclic) Policy |
| p2 (do not lose, o starts) | 55.69s | Strong (Cyclic) Policy |
| p3 (win, x starts) | 469.11s | Weak Plan |
| p4 (win, o starts) | 1800.12s | Weak Plan |

### Notakto

| Problem file | Time to solve (s) | Policy type |
|---|---:|---|
| p1 (win, p1 starts) | 3.47s | Strong (Cyclic) Policy |
| p2 (win, p2 starts) | 2.22s | Strong (Cyclic) Policy |

### Wild TicTacToe

| Problem file | Time to solve (s) | Policy type |
|---|---:|---|
| p1 (do not lose, p1 starts, standard) | 837.32s | Strong (Cyclic) Plan |
| p2 (do not lose, p2 starts, standard) | 2434.88s | Weak Plan |
| p3 (do not lose, p1 starts, misere) | 1800.17s | Weak Plan |
| p4 (do not lose, p2 starts, misere) | 756.67s | Strong (Cyclic) Plan |

## Final Notes
One observation we find interesting is that the weak plans aquired do not seem to be reliable. In the simulation itself there are many situations where the non-deterministic player can win, but the policy does not counter the action at all. Maybe that is a flaw in the encoding, but we can not quite explain where this comes from. The Strong (Cyclic) Plans on the other hand work extremely well and counter these possible winning moves effectively.