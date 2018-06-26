import React from "react";
import styles from "./styles"

var cn = require('classnames')

function Square(props) {
    const s = {
        backgroundColor: props.isWinner ? 'yellow' : 'none',
        fontWeight: props.isWinner ? 'bold' : 'normal'
    }
    return (
        <button style={s} className={cn(styles.square, styles.pink)} onClick={props.onClick}>
            {props.value}
        </button>
    );
}
export default Square
