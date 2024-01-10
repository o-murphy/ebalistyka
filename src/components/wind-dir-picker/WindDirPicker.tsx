import {useTheme} from "react-native-paper";
import React, {useState} from "react";
import {View} from "react-native";
import CircularSliderNative from "../circular-slider/CircularSliderNative";

import {Platform} from "react-native";
import CircularSlider from "../circular-slider/web/CircularSlider";


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
            {Platform.OS === "web"
                ?
                <CircularSlider
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
                :
                <CircularSliderNative
                    {...sliderValueHandler}
                    {...sliderProps}
                    {...sliderValues}
                    style={styles.slider}
                    dialRadius={80}
                />}
        </View>
    )
}