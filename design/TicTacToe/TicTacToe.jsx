import React from "react"
import Board from "./Board"
import styles from "./styles"

function calculateWinner(squares) {
    const lines = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
    ]
    for (let i = 0; i < lines.length; i++) {
        const [a, b, c] = lines[i]
        if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
            return [a, b, c]
        }
    }
    return []
}

class TicTacToe extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            history: [
                {
                    number: 0,
                    squares: Array(9).fill(null),
                    selected: null,
                }
            ],
            stepNumber: 0,
            xIsNext: true
        }
    }

    handleClick(i) {
        const history = this.state.history.slice(0, this.state.stepNumber + 1)
        const current = history[history.length - 1]
        const squares = current.squares.slice()
        if (calculateWinner(squares).length > 0 || squares[i]) {
            return
        }
        squares[i] = this.state.xIsNext ? 'X' : 'O'
        this.setState({
            history: history.concat([
                {
                    number: this.state.stepNumber,
                    squares: squares,
                    selected: i
                }
            ]),
            stepNumber: history.length,
            xIsNext: !this.state.xIsNext
        })
    }

    jumpTo(step) {
        this.setState({
            stepNumber: step,
            xIsNext: (step % 2) === 0
        })
    }

    reset() {
        this.setState({
            history: [{
                number: 0,
                squares: Array(9).fill(null),
                selected: null
            }],
            stepNumber: 0,
            xIsNext: !this.state.xIsNext
        })
    }

    render() {
        const history = this.state.history
        const current = history[this.state.stepNumber]
        const winner = calculateWinner(current.squares)

        const moves = history.map((step, move) => {
            const desc = move
                ? 'Move #' + move + ' (' + Math.floor(step.selected / 3) + ',' + (step.selected % 3) + ')'
                : 'Game start'
            const style = {
                fontWeight: this.state.stepNumber === move ? 'bold' : 'normal'
            }
            return (
                <li key={move}>
                    <button style={style} onClick={() => this.jumpTo(move)}>{desc}</button>
                </li>
            )
        })

        if (winner.length > 0) {
            status = 'Winner: ' + current.squares[winner[0]]
        } else if (history.length >= 9) {
            status = 'Cat\'s Game'
        } else {
            status = 'Next player: ' + (this.state.xIsNext ? 'X' : 'O')
        }

        return (
            <div className={styles.game}>
                <div className={styles.gameBoard}>
                    <Board
                        winner={winner}
                        squares={current.squares}
                        onClick={i => this.handleClick(i)} />
                </div>
                <div className={styles.gameInfo}>
                    <div>{status}</div>
                    <button className={styles.button} onClick={() => this.reset()}>End Game?</button>
                    <ol>{moves}</ol>
                </div>
            </div>
        );
    }
}
export default TicTacToe
