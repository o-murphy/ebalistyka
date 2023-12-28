import {Card} from "react-native-paper";
import React from "react";
import styleSheet from "../../styles/stylesheet";


const InputCard = ({
                       children,
                       title,
                   }) => {

    return (
        <Card mode="elevated" elevation={1} style={styleSheet.card.card}>
            <Card.Title title={title}/>
            <Card.Content style={styleSheet.card.content}>
                {children}
            </Card.Content>
        </Card>
    )
}


export default InputCard;