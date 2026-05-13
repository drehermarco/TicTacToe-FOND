import streamlit as st
import random
import re
import time
from pathlib import Path

# Helper for easy win condition checking
WIN_LINES = [
    (0, 1, 2),
    (3, 4, 5),
    (6, 7, 8),
    (0, 3, 6),
    (1, 4, 7),
    (2, 5, 8),
    (0, 4, 8),
    (2, 4, 6),
]

GAME_TYPES = ["tictactoe", "misere", "notakto", "wild"]
POLICY_DIR = Path("policies")

# Here the human readable policy files are parsed into a dictionary mapping board states to actions
def load_policy(path):
    rules = {}

    with open(path) as f:
        lines = [l.rstrip() for l in f]

    filtered_lines = []
    i = 0
    while i < len(lines):
        if i + 1 < len(lines):
            if lines[i + 1].startswith("Execute: place-x") and (str(path).startswith("policies/tictactoe") or str(path).startswith("policies/misere")):
                filtered_lines.append(lines[i])
                filtered_lines.append(lines[i + 1])
                i += 2
                continue
            elif lines[i + 1].startswith("Execute: p1-x") and str(path).startswith("policies/notakto"):
                filtered_lines.append(lines[i])
                filtered_lines.append(lines[i + 1])
                i += 2
                continue
            elif lines[i + 1].startswith("Execute: place") and str(path).startswith("policies/wild"):
                filtered_lines.append(lines[i])
                filtered_lines.append(lines[i + 1])
                i += 2
                continue
        i += 1
    
    state = None

    for line in filtered_lines:
        if line.startswith("If holds:"):
            line = line.replace("If holds:", "")
            state = ""
            for l in line.split("/"):
                l = l.strip()
                if str(path).startswith("policies/notakto"):
                    if l.startswith("x"):
                        state += "X"
                    elif l.startswith("not(x("):
                        state += "_"
                else: 
                    if l.startswith("empty"):
                        state += "_"
                    elif l.startswith("x"):
                        state += "X"
                    elif l.startswith("<none of those>"):
                        state += "O"
        elif line.startswith("Execute:") and state is not None:
            action = line.split(":")[1].strip()
            action = " ".join(action.split()[:2])
            rules[state] = action
            state = None
    # Debug print to verify rules are loaded correctly
    for rule in rules:
        print(f"{rule} -> {rules[rule]}")
    return rules

# Check for three equal symbols in a row
def three_in_row(board, game_type=None):
    for a, b, c in WIN_LINES:
        if game_type == "notakto":
            if board[a] != "_"and board[b] != "_" and board[c] != "_":
                return True
        else:
            if board[a] != "_" and board[a] == board[b] == board[c]:
                return board[a]
    return None


# Function for checking the different game types for a winner
def check_game_result(board, game_type, turn):
    winner = three_in_row(board, game_type)

    if game_type == "tictactoe":
        return winner

    elif game_type == "misere":
        if winner == "X":
            return "O"
        elif winner == "O":
            return "X"

    elif game_type == "notakto":
        if winner:
            return turn

    elif game_type == "wild":
        return winner

    return None


def get_policy_symbol(action):
    if action.startswith("place-x") or action.startswith("p1-x"):
        return "X"
    if action.startswith("place-o") or action.startswith("p2-o"):
        return "O"
    return None


def get_action_position(action):
    m = re.search(r"\bt(\d)\b", action)
    if not m:
        return None
    return int(m.group(1))


def apply_policy_move(board, rules, fallback_symbol="X"):
    if board not in rules:
        return board
    action = rules[board]
    symbol = get_policy_symbol(action)

    if symbol is None:
        symbol = fallback_symbol
    pos = get_action_position(action)

    if pos is None or not (1 <= pos <= 9):
        return board

    idx = pos - 1
    if board[idx] != "_":
        return board

    b = list(board)
    b[idx] = symbol
    return "".join(b)


def random_move(board, symbol):
    b = list(board)
    empties = [i for i, v in enumerate(b) if v == "_"]
    if not empties:
        return board

    pick = random.choice(empties)
    b[pick] = symbol
    return "".join(b)


def get_random_symbol(game_type, turn):
    # only X is allowed for the random player
    if game_type == "notakto":
        return "X"

    # both X and O are allowed for the random player
    if game_type == "wild":
        return random.choice(["X", "O"])

    return turn

def render_board(board):
    cells = "".join(
        f"<div class='cell'>{'' if board[i] == '_' else board[i]}</div>"
        for i in range(9)
    )

    html = f"""
    <style>

        .ttt-wrapper {{
            display:flex;
            justify-content:center;
            margin:20px 0;
        }}

        .ttt-board {{
            display:grid;
            grid-template-columns:repeat(3, 120px);
            gap:0px;
        }}

        .ttt-board .cell {{
            font-size:56px;
            text-align:center;
            border:1px solid #ccc;
            width:120px;
            height:120px;
            display:flex;
            align-items:center;
            justify-content:center;
            box-sizing:border-box;
        }}

        @media (max-width:500px) {{

            .ttt-board {{
                grid-template-columns:repeat(3, 1fr);
            }}

            .ttt-board .cell {{
                width:auto;
                height:60px;
                font-size:40px;
            }}
        }}

    </style>

    <div class='ttt-wrapper'>
        <div class='ttt-board'>
            {cells}
        </div>
    </div>
    """

    st.markdown(html, unsafe_allow_html=True)


def policy_action_for_board(board, rules):
    if board not in rules:
        return None
    return rules[board]

st.set_page_config(
    page_title="Policy Simulation",
    layout="centered"
)

st.title("Policy Simulation for Tic-Tac-Toe Variants")

# Sidebar needed for selecting the different game or policy files
selected_game = st.sidebar.selectbox(
    "Game Variant",
    GAME_TYPES
)

policy_files = []
game_policy_dir = POLICY_DIR / selected_game

if game_policy_dir.exists():
    policy_files = sorted([
        p.stem
        for p in game_policy_dir.glob("*.pol")
    ])

if not policy_files:
    st.error(f"No policy files found in {game_policy_dir}")
    st.stop()

selected_policy = st.sidebar.selectbox(
    "Policy File",
    policy_files
)

policy_path = game_policy_dir / f"{selected_policy}.pol"

if "board" not in st.session_state:
    st.session_state.board = "_________"

if "turn" not in st.session_state:
    st.session_state.turn = "X"

if "auto_simulate" not in st.session_state:
    st.session_state.auto_simulate = False

if "last_game" not in st.session_state:
    st.session_state.last_game = None

if "last_policy" not in st.session_state:
    st.session_state.last_policy = None

# Reload when game/policy changes
if (
    st.session_state.last_game != selected_game
    or st.session_state.last_policy != selected_policy
):

    st.session_state.board = "_________"
    st.session_state.turn = "X"

    st.session_state.rules = load_policy(policy_path)

    st.session_state.last_game = selected_game
    st.session_state.last_policy = selected_policy

board = st.session_state.board
turn = st.session_state.turn
rules = st.session_state.rules
winner = check_game_result(board, selected_game, turn)

if winner:
    if winner == "X":
        status_text = "Winner P1"
    else:
        status_text = "Winner P2"
elif "_" not in board:
    status_text = "Draw"
else:
    if turn == "X":
        turn_text = "P1"
    else:
        turn_text = "P2"
    status_text = f"In Progress ({turn_text} to move)"

st.markdown(f"### Status: {status_text}")

render_board(board)
suggested = policy_action_for_board(board, rules)

if suggested:
    st.info(f"Policy move: {suggested}")
else:
    st.info("Opponent moves randomly (only valid moves shown here)")

def simulate_single_step():
    current_board = st.session_state.board
    current_turn = st.session_state.turn

    current_winner = check_game_result(current_board, selected_game, current_turn)
    is_draw = "_" not in current_board

    # Reset after terminal state
    if current_winner or is_draw:
        st.session_state.board = "_________"
        st.session_state.turn = "X"
        return

    if current_turn == "X":
        symbol = get_random_symbol(selected_game, "X")
        st.session_state.board = apply_policy_move(
            current_board,
            rules,
            fallback_symbol=symbol
        )

        st.session_state.turn = "O"
    else:
        symbol = get_random_symbol(selected_game, "O")

        st.session_state.board = random_move(
            current_board,
            symbol
        )

        st.session_state.turn = "X"

col1, col2, col3 = st.columns(3)
with col1:
    if st.button("Step"):
        simulate_single_step()
        st.rerun()

with col2:
    if st.button("Reset"):
        st.session_state.board = "_________"
        st.session_state.turn = "X"
        st.rerun()

with col3:
    label = (
        "Auto Simulate: ON"
        if st.session_state.auto_simulate
        else "Auto Simulate: OFF"
    )

    if st.button(label):
        st.session_state.auto_simulate = (
            not st.session_state.auto_simulate
        )
        st.rerun()

if st.session_state.auto_simulate:
    time.sleep(0.25)
    simulate_single_step()
    st.rerun()

with st.expander("Loaded Policy (sample)"):
    st.write(f"Rules loaded: {len(rules)}")
    shown = 0
    for s, a in rules.items():
        st.code(f"{s}  ->  {a}")
        shown += 1
        if shown >= 20:
            break