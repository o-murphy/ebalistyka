import {Card, Text, useTheme} from "react-native-paper"
import UnitPicker from "../unit-picker/UnitPicker"
import {Col, Grid, Row} from "react-native-paper-grid";

import {
    Unit,
    UnitProps,
    Measure,
} from "js-ballistics"
import {Dimensions, StyleSheet, View} from "react-native";


const get_unit_list = (measure: Object) =>
    Object.keys(measure).map((key: string): { label: string, value: Unit } => {
        return {label: UnitProps[measure[key]].name, value: measure[key]}
    })

const init_unit_list = [
    {
        key: "distance",
        label: "Distance",
        list: get_unit_list(Measure.Distance),
        def: Unit.Meter
    },
    {
        key: "velocity",
        label: "Velocity",
        list: get_unit_list(Measure.Velocity),
        def: Unit.MPS
    },
    {
        key: "angular",
        label: "Angular",
        list: get_unit_list(Measure.Angular),
        def: Unit.Degree
    },
    {
        key: "sight_height",
        label: "Sight height",
        list: get_unit_list(Measure.Distance),
        def: Unit.Inch
    },
    {
        key: "length",
        label: "Length",
        list: get_unit_list(Measure.Distance),
        def: Unit.Inch
    },
    {
        key: "diameter",
        label: "Diameter",
        list: get_unit_list(Measure.Distance),
        def: Unit.Inch
    },
    {
        key: "weight",
        label: "Weight",
        list: get_unit_list(Measure.Weight),
        def: Unit.Grain
    },
    {
        key: "temperature",
        label: "Temperature",
        list: get_unit_list(Measure.Temperature),
        def: Unit.Celsius
    },
    {
        key: "pressure",
        label: "Pressure",
        list: get_unit_list(Measure.Pressure),
        def: Unit.PSI
    },
    {
        key: "energy",
        label: "Energy",
        list: get_unit_list(Measure.Energy),
        def: Unit.Joule
    },
    {
        key: "adjustment",
        label: "Adjustment",
        list: get_unit_list(Measure.Angular),
        def: Unit.MIL
    },
]


export default function SettingsUnitCard() {

    const theme = useTheme();

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
    });

    return (

        <Card mode="elevated" elevation={1} style={{margin: 10, padding: 5}}>
            <Card.Title title="Units of measurement"/>

            <Card.Content style={{marginHorizontal: 0, paddingHorizontal: 10}}>


                <Grid style={styles.grid}>

                    {/*<Text variant="titleMedium" style={{marginVertical: 10, fontWeight: "bold"}}>Units of measurement</Text>*/}

                    {init_unit_list.map((field) =>
                        <Row style={styles.row} key={field.key}>
                            <Col>
                                <Text>{field.label}</Text>
                            </Col>
                            <Col>
                                <UnitPicker props={field}/>
                            </Col>
                        </Row>
                    )}

                </Grid>


            </Card.Content>
        </Card>


    )

}