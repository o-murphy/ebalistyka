import {Text, useTheme} from "react-native-paper";
import React from "react";
import {View} from "react-native";
import CircularSlider from "../circular-slider";
import CircleSlider from "../circular-slider/CircleSlider";


export default function WindDirection({curValue, onChange}) {
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
            fontWeight: "bold"
        },
        slider: {},
    }

    return (

        <View style={styles.container}>

            <CircleSlider value={curValue}
                          dialRadius={100}
                          btnRadius={15}
                          btnColor={theme.colors.outline}
                          min={0}
                          max={359}
                          dialWidth={15}
                          meterColor={theme.colors.secondaryContainer}
                          textColor={theme.colors.onSecondaryContainer}
                //           fillColor={theme.colors.secondaryContainer}
                //           btnColor={theme.colors.secondaryContainer}
                          strokeColor={theme.colors.secondaryContainer}
                          strokeWidth={20}
                          textSize={0}
                          onValueChange={value => onChange(Math.round(value / 30))}
                          style={[styles.slider, {padding: 5}]}/>


            <Text variant={"titleMedium"} style={styles.text}>{`${curValue * 30}° (${curValue}h)`}</Text>


        </View>
    )
}