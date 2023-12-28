import {Card, Text, TextInput, useTheme} from "react-native-paper";
import LanguagePicker from "../language-picker/LanguagePicker";
import UnitPicker from "../unit-picker/UnitPicker";
import {Col, Grid, Row} from "react-native-paper-grid";
import MeasurePicker from "../measure-picker/measurePicker";
import React, {useState} from "react";
import {Dimensions, StyleSheet} from "react-native";
import DropDown from "react-native-paper-dropdown";


export default function RifleCard() {

    const theme = useTheme();

    const fields = [
        {
            label: "Diameter",
            inputProps: {
                initialValue: 0.308,
                maxValue: 22,
                minValue: 0.001,
                maxLength: 8,
                maxDecimals: 3,
            }
        },
        {
            label: "Twist",
            inputProps: {
                initialValue: 11,
                maxValue: 20,
                minValue: -20,
                maxLength: 8,
                maxDecimals: 2,
            }
        },
        // twistDir: {
        //     label: "Twist",
        //     inputProps: {
        //         initialValue: 11,
        //         maxValue: 20,
        //         minValue: -20,
        //         maxLength: 8,
        //         maxDecimals: 2
        //     }
        // }
    ]

    const styles = StyleSheet.create({
        grid: {
            flex: 1,
        },
        row: {
            flex: 1,
            alignItems: "center",
        },
        col: {
            flex: 1,
        },
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
            height: Dimensions.get('window').height * 0.8, // Set the height as a percentage of the screen height
            marginBottom: 80
        },
    });

    const [showDropDown, setShowDropDown] = useState(false);
    const [twistDir, setTwistDir] = useState("Right");
    const twistDirs = [
        {
            label: "Right",
            value: "Right",
        },
        {
            label: "Left",
            value: "Left",
        },
    ];

    return (
        <Card mode="elevated" elevation={1} style={{margin: 10, padding: 10}}>
            <Card.Title title="Weapon"/>

            <Card.Content style={{marginHorizontal: 10, paddingHorizontal: 10}}>

                {/*<Text variant="titleMedium" style={{marginVertical: 10}}>Weapon</Text>*/}

                <Grid style={styles.grid}>
                    {
                        fields.map(field => {
                            return (
                                <Row style={styles.row}>
                                    <Col size={2}>
                                        <Text>{field.label}</Text>
                                    </Col>
                                    <Col size={1}>
                                        <MeasurePicker {...field.inputProps} />
                                    </Col>
                                </Row>)
                        })
                    }

                    <Row style={styles.row}>
                        <Col size={2}>
                            <Text>Twist direction</Text>
                        </Col>
                        <Col size={1}>
                            <DropDown
                                // label={" "}
                                mode={"flat"}
                                visible={showDropDown}
                                showDropDown={() => setShowDropDown(true)}
                                onDismiss={() => setShowDropDown(false)}
                                value={twistDir}
                                setValue={setTwistDir}
                                list={twistDirs}

                                inputProps = {{
                                    style: {marginVertical: 8},
                                    dense: true,
                                    right: <TextInput.Icon icon="chevron-down" onPress={() => setShowDropDown(true)}/>
                                }}

                            />
                        </Col>
                    </Row>


                </Grid>

            </Card.Content>
        </Card>
    )
}