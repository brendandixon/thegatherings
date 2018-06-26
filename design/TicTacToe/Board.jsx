import React from "react";
import Square from "./Square"
import styles from "./styles"

class Board extends React.Component {
    renderSquare(i) {
        const isWinner = this.props.winner.includes(i)
        return (
            <Square
                key={i.toString() + isWinner.toString()}
                isWinner={isWinner}
                value={this.props.squares[i]}
                onClick={() => this.props.onClick(i)}
            />
        )
    }

    renderRow(i) {
        return <div key={i} className={styles.boardRow}>{[0, 1, 2].map(j => this.renderSquare((3 * i) + j))}</div>
    }

    render() {
        return <div>{[0, 1, 2].map(i => this.renderRow(i))}</div>
    }
}
export default Board
