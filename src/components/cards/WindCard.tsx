import {Text} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {SimpleDialog} from "../dialogs";
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
            mode: "float" as const,
            initialValue: 0,
            maxValue: 100,
            minValue: 0,
            decimals: 1,
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

    const getWindIcon = () => {
        switch (curWindDir / 30) {
            case 12:
                return "clock-time-twelve-outline";
            case 11:
                return "clock-time-eleven-outline";
            case 10:
                return "clock-time-ten-outline";
            case 9:
                return "clock-time-nine-outline";
            case 8:
                return "clock-time-eight-outline";
            case 7:
                return "clock-time-seven-outline";
            case 6:
                return "clock-time-six-outline";
            case 5:
                return "clock-time-five-outline";
            case 4:
                return "clock-time-four-outline";
            case 3:
                return "clock-time-three-outline";
            case 2:
                return "clock-time-two-outline";
            case 1:
                return "clock-time-one-outline";
            case 0:
                return "clock-time-twelve-outline";

        }
    }

    return (

        <InputCard title={"Current wind"}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}


                <Row style={styleSheet.grid.row}>
                    <Col>
                        <Text style={{fontSize: 16}}>{"Wind direction"}</Text>
                    </Col>
                    <Col>
                        <SimpleDialog label={`Wind direction, degree`}
                                      text={`${curWindDir}° (${curWindDir / 30}h)`}
                                      icon={getWindIcon()}
                                      onAccept={onWindAccept}
                                      onDecline={onWindDecline}>
                            <WindDirectionPicker
                                value={windDir}
                                onChange={onWindDirChange}/>
                        </SimpleDialog>
                    </Col>
                </Row>

                {/*<Row>*/}
                {/*    <Col>*/}
                {/*        <Text>{"Wind direction"}</Text>*/}
                {/*    </Col>*/}

                {/*    <Col>*/}
                {/*        <CircularSlider.tsx*/}
                {/*            size={200}*/}
                {/*            trackWidth={8}*/}
                {/*            minValue={0}*/}
                {/*            maxValue={12}*/}
                {/*            startAngle={0}*/}
                {/*            endAngle={360}*/}
                {/*            angleType={{direction: "cw", axis: "+y"}}*/}
                {/*            handleSize={10}*/}
                {/*            handle1={{*/}
                {/*                value: 50,*/}
                {/*                onChange: () => {},*/}
                {/*            }}*/}
                {/*            arcBackgroundColor={"white"}*/}
                {/*            arcColor={"black"}*/}
                {/*            capMode={"triangle"}*/}
                {/*        />*/}

                {/*    </Col>*/}
                {/*</Row>*/}

            </Grid>
        </InputCard>
    )
}