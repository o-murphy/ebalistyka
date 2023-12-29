import {Text} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import MeasurePicker from "../measure-picker/MeasurePicker";
import React from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";


export default function AtmoCard() {

    const fields = [
        {
            key: "temp",
            label: "Temperature",
            suffix: "C",
            icon: "thermometer",
            inputProps: {
                initialValue: 15,
                maxValue: 50,
                minValue: -50,
                maxLength: 4,
                maxDecimals: 1
            }
        },
        {
            key: "pressure",
            label: "Pressure",
            suffix: "mmHg",
            icon: "speedometer",
            inputProps: {
                initialValue: 760,
                maxValue: 1000,
                minValue: 700,
                maxLength: 6,
                maxDecimals: 0
            }
        },
        {
            key: "humidity",
            label: "Humidity",
            suffix: "%",
            icon: "water",
            inputProps: {
                initialValue: 78,
                maxValue: 100,
                minValue: 0,
                maxLength: 3,
                maxDecimals: 0
            }
        },
        {
            key: "altitude",
            label: "Altitude",
            suffix: "m",
            icon: "ruler",
            inputProps: {
                initialValue: 150,
                maxValue: 3000,
                minValue: 0,
                maxLength: 8,
                maxDecimals: 0,
            }
        },
    ]

    return (

        <InputCard title={"Current atmosphere"}>
            <Grid style={styleSheet.grid.grid}>
                {
                    fields.map(field => {
                        return (
                            <Row style={styleSheet.grid.row} key={field.key}>
                                <Col size={6}>
                                    <Text>{field.label}</Text>
                                </Col>
                                <Col size={4}>
                                    <SimpleModal icon={field.icon} title={`${field.label}, ${field.suffix}`}
                                                  text={`${field.inputProps.initialValue} ${field.suffix}`}
                                    >
                                        <MeasurePicker {...field.inputProps} />
                                    </SimpleModal>
                                </Col>
                            </Row>)
                    })
                }
            </Grid>
        </InputCard>
    )
}