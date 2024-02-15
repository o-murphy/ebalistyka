import {Text, TextInput, Chip} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {SimpleDialog} from "../dialogs";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";
import {Unit, UnitProps} from "js-ballistics";
import {navigate} from "../../RootNavigation";


export default function BulletCard() {

    const fields = [
        {
            key: "diameter",
            label: "Diameter",
            suffix: UnitProps[Unit.Inch].symbol,
            icon: "diameter-variant",
            mode: "float" as const,
            initialValue: 0.308,
            maxValue: 22,
            minValue: 0.001,
            decimals: 3,
        },
        {
            key: "weight",
            label: "Weight",
            suffix: UnitProps[Unit.Grain].symbol,
            icon: "weight",
            mode: "float" as const,
            initialValue: 15,
            maxValue: 50,
            minValue: -50,
            decimals: 1,
        },
        {
            key: "length",
            label: "Length",
            suffix: UnitProps[Unit.Inch].symbol,
            icon: "arrow-expand-horizontal",
            // icon: "⬌",
            mode: "float" as const,
            initialValue: 1.7,
            maxValue: 5,
            minValue: 0,
            decimals: 2,
        },
    ]

    const [curName, setCurName] = React.useState("My bullet");
    const [name, setName] = React.useState(curName);

    const acceptName = () => {
        setCurName(name)
    }

    const declineName = () => {
        setName(curName)
    }

    const editDragModel = () => {
        navigate("DragModelScreen")
    }

    return (

        <InputCard title={"Bullet"}>

            <SimpleDialog label={"Name"} icon={"card-bulleted-outline"}
                          text={curName}
                          onAccept={acceptName}
                          onDecline={declineName}
            >
                <TextInput value={name} onChangeText={setName}/>
            </SimpleDialog>

            <Grid style={styleSheet.grid.grid}>

                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}

                <Row style={styleSheet.grid.row}>
                    <Col size={8}>
                        <Text style={{fontSize: 16}}>Drag model</Text>
                    </Col>
                    <Col size={8}>

                        <Chip icon={"function"} closeIcon="square-edit-outline" style={{margin: 0}} textStyle={{fontSize: 16}}
                              onPress={editDragModel}
                              onClose={editDragModel}
                        >
                            {`0.318 G7`}
                        </Chip>

                    </Col>
                </Row>

            </Grid>
        </InputCard>

    )
}