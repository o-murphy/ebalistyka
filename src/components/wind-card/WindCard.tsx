import {Text, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import IntPicker from "../int-picker/IntPicker";
import FloatPicker from "../float-picker/FloatPicker";
import {Unit, UnitProps} from "js-ballistics";
// import CircularSlider from "react-circular-slider-svg";
import CircularSlider from "../circular-slider";

export default function WindCard() {

    const theme = useTheme()

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
            }
        }
    ]

    const [windDir, setWindDir] = useState(0)

    const onWindDirChange = (value) => {
        setWindDir(value === 12 ? 0 : value)
    }

    const createField = (field) => {

        const [curValue, setCurValue] = useState(field.inputProps.initialValue);
        const [value, setValue] = useState(curValue)

        const onAccept = () => {
            setCurValue(value)
        }

        return (
            <Row style={styleSheet.grid.row} key={field.key}>
                <Col size={8}>
                    <Text>{field.label}</Text>
                </Col>
                <Col size={8}>
                    <SimpleModal icon={field.icon} title={`${field.label}, ${field.suffix}`}
                                 text={`${curValue} ${field.suffix}`}
                                 onAccept={onAccept}>
                        {
                            field.inputProps.mode === "int"
                                ? <IntPicker  {...field.inputProps} initialValue={curValue} onChange={setValue}/>
                                : <FloatPicker  {...field.inputProps} initialValue={curValue} onChange={setValue}/>
                        }
                    </SimpleModal>
                </Col>
            </Row>)
    }

    return (

        <InputCard title={"Current wind"}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(createField)}

                <Row style={styleSheet.grid.row}>
                    <Col>
                        <Text>{"Wind direction"}</Text>
                    </Col>
                    <Col>
                        <CircularSlider
                            size={150}
                            trackWidth={10}
                            minValue={0}
                            maxValue={12}
                            startAngle={0}
                            endAngle={360}
                            angleType={{
                                direction: "cw",
                                axis: "+y"
                            }}
                            handle1={{
                                value: windDir,
                                onChange: v => onWindDirChange(v)
                            }}
                            coerceToInt={true}
                            // arcColor={theme.colors.onSecondaryContainer}
                            arcColor={theme.colors.secondaryContainer}
                            arcBackgroundColor={theme.colors.secondaryContainer}
                        />
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )
}