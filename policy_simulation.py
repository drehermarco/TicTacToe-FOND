import streamlit as st
import random
import re
import time

def load_policy(path="test.pol"):
    rules = {}
    with open(path) as f:
        lines = [l.rstrip() for l in f]

    filtered_lines = []
    i = 0
    while i < len(lines):
        if i + 1 < len(lines):
            if lines[i + 1].startswith("Execute: place-x"):
                filtered_lines.append(lines[i])
                filtered_lines.append(lines[i + 1])
                i += 2
                continue
        i += 1

    state = None
    for line in filtered_lines:
        if line.startswith("If holds:"):
            state = ""
            for l in line.split("/"):
                l = l.strip()
                if l.startswith("empty"): state += "_"
                elif l.startswith("x"): state += "X"
                elif l.startswith("<none of those>"): state += "O"
        elif line.startswith("Execute:") and state is not None:
            action = line.split(":")[1].strip()
            action = " ".join(action.split()[1:3])
            rules[state] = action
            state = None
    return rules

def apply_policy_move(board, rules):
    if board in rules:
        act = rules[board]
        m = re.search(r"r(\d)\s*c(\d)", act)
        if m:
            r, c = int(m.group(1)), int(m.group(2))
            idx = (r - 1) * 3 + (c - 1)
            if board[idx] == '_':
                b = list(board)
                b[idx] = 'X'
                return "".join(b)
    return board

def random_o_move(board):
    b = list(board)
    empties = [i for i, v in enumerate(b) if v == '_']
    if not empties:
        return board
    pick = random.choice(empties)
    b[pick] = 'O'
    return "".join(b)

def check_winner(b):
    wins = [(0,1,2),(3,4,5),(6,7,8),
            (0,3,6),(1,4,7),(2,5,8),
            (0,4,8),(2,4,6)]

    for a,c,d in wins:
        if b[a] != '_' and b[a] == b[c] == b[d]:
            return b[a]
    return None


st.set_page_config(page_title="Policy Simulation", layout="centered")

st.title("Policy Simulation for Tic Tac Toe")

if "board" not in st.session_state:
    st.session_state.board = "_________"
    st.session_state.turn = "X"
    st.session_state.rules = load_policy()
if "auto_simulate" not in st.session_state:
    st.session_state.auto_simulate = False

board = st.session_state.board
rules = st.session_state.rules
turn = st.session_state.turn

winner = check_winner(board)

def policy_action_for_board(board, rules):
    if board not in rules:
        return None
    act = rules[board]
    m = re.search(r"r(\d)\s*c(\d)", act)
    if not m:
        return None
    return f"place-x r{m.group(1)} c{m.group(2)}"

def render_board(board):
        cells = "".join(f"<div class='cell'>{board[i]}</div>" for i in range(9))
        html = f"""
        <style>
            .ttt-wrapper {{ display:flex; justify-content:center; margin:20px 0; }}
            .ttt-board {{ display: grid; grid-template-columns: repeat(3, 120px); gap: 0px; }}
            .ttt-board .cell {{ font-size:56px; text-align:center; border:1px solid #ccc; padding:0; width:120px; height:120px; display:flex; align-items:center; justify-content:center; box-sizing:border-box; }}
            @media (max-width:500px) {{ .ttt-board {{ grid-template-columns: repeat(3, 1fr); }} .ttt-board .cell {{ width:auto; height:60px; font-size:40px; }} }}
        </style>
        <div class='ttt-wrapper'><div class='ttt-board'>{cells}</div></div>
        """
        st.markdown(html, unsafe_allow_html=True)

if winner:
    status_text = f"Status: Winner {winner}"
elif '_' not in board:
    status_text = "Status: Draw"
else:
    status_text = f"Status: In progress ({turn} to move)"

st.markdown(f"### {status_text}")

render_board(board)

suggested = policy_action_for_board(board, rules)
if suggested:
    st.info(f"Policy for this state: {suggested}")
else:
    st.info("Opponent 'O' places randomly")

col1, col2, col3 = st.columns(3)

with col1:
    if st.button("Step") and not winner:
        if st.session_state.turn == "X":
            st.session_state.board = apply_policy_move(st.session_state.board, rules)
            st.session_state.turn = "O"
        else:
            st.session_state.board = random_o_move(st.session_state.board)
            st.session_state.turn = "X"
        st.rerun()

with col2:
    if st.button("Reset"):
        st.session_state.board = "_________"
        st.session_state.turn = "X"
        st.rerun()

with col3:
    auto_label = "Auto Simulate: ON" if st.session_state.auto_simulate else "Auto Simulate: OFF"
    if st.button(auto_label):
        st.session_state.auto_simulate = not st.session_state.auto_simulate
        st.rerun()

if st.session_state.auto_simulate:
    time.sleep(1.25)
    current_winner = check_winner(st.session_state.board)
    is_draw = '_' not in st.session_state.board

    if current_winner or is_draw:
        st.session_state.board = "_________"
        st.session_state.turn = "X"
    else:
        if st.session_state.turn == "X":
            st.session_state.board = apply_policy_move(st.session_state.board, rules)
            st.session_state.turn = "O"
        else:
            st.session_state.board = random_o_move(st.session_state.board)
            st.session_state.turn = "X"
    st.rerun()

with st.expander("Loaded Policy (sample)"):
    st.write(f"Rules loaded: {len(rules)}")
    # show up to first 20 rules
    shown = 0
    for s, a in rules.items():
        st.code(f"{s}  ->  {a}")
        shown += 1
        if shown >= 20:
            break