import {Text} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import {Unit, UnitProps} from "js-ballistics";
import WindDirectionPicker from "../wind-dir-picker/WindDirPicker";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";


export default function WindCard() {

    const fields = [
        {
            key: "windSpeed",
            label: "Wind speed",
            suffix: UnitProps[Unit.MPS].symbol,
            icon: "windsock",
            inputProps: {
                mode: "int",
                initialValue: 0,
                maxValue: 100,
                minValue: 0,
                decimals: 0,
            }
        }
    ]

    const [curWindDir, setCurWindDir] = useState(0)
    const [windDir, setWindDir] = useState(curWindDir / 30)

    const onWindDirChange = (value) => {
        setWindDir(value === 12 ? 0 : value)
    }

    const onWindAccept = () => {
        setCurWindDir(windDir * 30)
    }

    const onWindDecline = () => {
        setWindDir(curWindDir / 30)
    }

    return (

        <InputCard title={"Current wind"}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}


                <Row style={styleSheet.grid.row}>
                    <Col>
                        <Text>{"Wind direction"}</Text>
                    </Col>
                    <Col>
                        <SimpleModal title={`WindDirection, degree`}
                                     text={`${curWindDir}° (${curWindDir / 30}h)`}
                                     onAccept={onWindAccept}
                                     onDecline={onWindDecline}>
                            <WindDirectionPicker
                                curValue={windDir}
                                onChange={onWindDirChange}/>
                        </SimpleModal>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )
}