import {Card, Text, TextInput, useTheme} from "react-native-paper";
import LanguagePicker from "../language-picker/LanguagePicker";
import UnitPicker from "../unit-picker/UnitPicker";
import {Col, Grid, Row} from "react-native-paper-grid";
import MeasurePicker from "../measure-picker/MeasurePicker";
import React, {useState} from "react";
import {Dimensions, StyleSheet} from "react-native";
import DropDown from "react-native-paper-dropdown";


export default function AtmoCard() {

    const theme = useTheme();

    const fields = [
        {
            key: "temp",
            label: "Temperature",
            suffix: "C",
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
            inputProps: {
                initialValue: 150,
                maxValue: 3000,
                minValue: 0,
                maxLength: 8,
                maxDecimals: 0,
            }
        },
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

    return (
        <Card mode="elevated" elevation={1} style={{margin: 10, padding: 5}}>
            <Card.Title title="Current atmosphere"/>

            <Card.Content style={{marginHorizontal: 0, paddingHorizontal: 10}}>

                <Grid style={styles.grid}>
                    {
                        fields.map(field => {
                            return (
                                <Row style={styles.row} key={field.key}>
                                    <Col size={5}>
                                        <Text>{field.label}</Text>
                                    </Col>
                                    <Col size={4}>
                                        <MeasurePicker {...field.inputProps} />
                                    </Col>
                                    <Col size={1}>
                                        <Text>{field.suffix}</Text>
                                    </Col>
                                </Row>)
                        })
                    }

                </Grid>

            </Card.Content>
        </Card>
    )
}