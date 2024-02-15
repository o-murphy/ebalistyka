import {useTheme} from "react-native-paper";
import React from "react";
import {View} from "react-native";
import CircularSliderNative from "../circular-slider/CircularSliderNative";


export default function WindDirection({value, onChange}) {

    const theme = useTheme()

    const styles = {
        container: {
            // flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            paddingBottom: 40,
        },
        text: {
            marginTop: -110,
            fontWeight: "bold",
            fontSize: 16,
            textAlign: "center"
        },
        slider: {
            padding: 5
        },
    }

    const sliderProps = {
        coerceToInt: true,
        capMode: "triangle",

        handleSize: 10,
        arcWidth: 20,
        strokeWidth: 20,
        meterTextSize: 20,

        handleColor: theme.colors.outline,
        arcColor: theme.colors.secondaryContainer,
        strokeColor: theme.colors.secondaryContainer,
        meterTextColor: theme.colors.outline,
    }

    const sliderValues = {
        minValue: 0,
        maxValue: 12,
        meterText: `${value * 30}° (${value}h)`
    }

    const sliderValueHandler = {
        value: value,
        onChange: onChange
    }

    return (
        <View style={styles.container}>
            <CircularSliderNative
                {...sliderValueHandler}
                {...sliderProps}
                {...sliderValues}
                style={styles.slider}
                dialDiameter={240}
                angleType={{
                    direction: "cw",
                    axis: "+y"
                }}
            />
        </View>
    )
}