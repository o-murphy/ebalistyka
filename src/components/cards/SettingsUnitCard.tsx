import {Text} from "react-native-paper"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "./InputCard";
import styleSheet from "../../styles";


import {
    Unit,
    UnitProps,
    Measure,
} from "js-ballistics"
import SimpleDialog from "../simple-modal/SimpleDialog";
import {useState} from "react";
import RadioGroup from "../radio-group/RadioGroup";


const get_unit_list = (measure: Object) =>
    Object.keys(measure).map((key: string): { label: string, value: Unit } => {
        return {label: UnitProps[measure[key]].name, value: measure[key]}
    })

const fields = [
    {
        key: "distance",
        label: "Distance",
        list: [
            {label: UnitProps[Unit.Meter].name, value: Unit.Meter},
            {label: UnitProps[Unit.Foot].name, value: Unit.Foot},
            {label: UnitProps[Unit.Yard].name, value: Unit.Yard},
        ],
        def: Unit.Meter,
    },
    {
        key: "velocity",
        label: "Velocity",
        list: [
            {label: UnitProps[Unit.MPS].name, value: Unit.MPS},
            {label: UnitProps[Unit.FPS].name, value: Unit.FPS},
        ],
        def: Unit.MPS
    },
    {
        key: "angular",
        label: "Angular",
        list: get_unit_list(Measure.Angular),
        def: Unit.Degree
    },
    {
      key: "sizes",
      label: "Sizes",
    list: [
        {label: UnitProps[Unit.Inch].name, value: Unit.Inch},
        {label: UnitProps[Unit.Millimeter].name, value: Unit.Millimeter},
        {label: UnitProps[Unit.Centimeter].name, value: Unit.Centimeter},
        {label: UnitProps[Unit.Centimeter].name, value: Unit.Line},
    ],
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
        list: [
            {label: UnitProps[Unit.Celsius].name, value: Unit.Celsius},
            {label: UnitProps[Unit.Fahrenheit].name, value: Unit.Fahrenheit},
        ],
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

    const UnitSelector = ({field}) => {

        const [curValue, setCurValue] = useState(field.def);
        const [value, setValue] = useState(curValue)

        const onAccept = () => {
            setCurValue(value)
        }

        return (
            <Row style={styleSheet.grid.row} key={field.key}>
                <Col size={9}>
                    <Text style={{fontSize: 16}}>{field.label}</Text>
                </Col>
                <Col size={7}>
                    <SimpleDialog title={field.label} text={UnitProps[curValue].name} onAccept={onAccept}>
                        <RadioGroup initialValue={curValue} onChange={setValue} items={field.list} />
                    </SimpleDialog>
                </Col>
            </Row>
        )
    }


    return (
        <InputCard title="Units of measurement">
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <UnitSelector key={field.key} field={field}/>)}
            </Grid>
        </InputCard>
    )

}