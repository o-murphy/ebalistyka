import {Text} from "react-native-paper"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "./InputCard";
import styleSheet from "../../styles";


import {
    Unit,
    UnitProps,
    Measure,
} from "js-ballistics"
import {SimpleScrollDialog} from "../dialogs";
import {useState} from "react";
import RadioGroup from "../radio-group/RadioGroup";
import {useTranslate} from "../../translations/UseTranslate";


const get_unit_list = (measure: Object) =>
    Object.keys(measure).map((key: string): { label: string, value: Unit } => {
        return {label: UnitProps[measure[key]].name, value: measure[key]}
    })


export default function SettingsUnitCard() {
    // translator
    const me = SettingsUnitCard.name
    const translator = useTranslate()
    const tr = (str) => translator(me, str)

    const fields = [
        {
            key: "distance",
            label: tr("Distance"),
            list: [
                {label: UnitProps[Unit.Meter].name, value: Unit.Meter},
                {label: UnitProps[Unit.Foot].name, value: Unit.Foot},
                {label: UnitProps[Unit.Yard].name, value: Unit.Yard},
            ],
            def: Unit.Meter,
        },
        {
            key: "velocity",
            label: tr("Velocity"),
            list: [
                {label: UnitProps[Unit.MPS].name, value: Unit.MPS},
                {label: UnitProps[Unit.FPS].name, value: Unit.FPS},
            ],
            def: Unit.MPS
        },
        {
            key: "angular",
            label: tr("Angular"),
            list: get_unit_list(Measure.Angular),
            def: Unit.Degree
        },
        {
            key: "sizes",
            label: tr("Sizes"),
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
            label: tr("Weight"),
            list: get_unit_list(Measure.Weight),
            def: Unit.Grain
        },
        {
            key: "temperature",
            label: tr("Temperature"),
            list: [
                {label: UnitProps[Unit.Celsius].name, value: Unit.Celsius},
                {label: UnitProps[Unit.Fahrenheit].name, value: Unit.Fahrenheit},
            ],
            def: Unit.Celsius
        },
        {
            key: "pressure",
            label: tr("Pressure"),
            list: get_unit_list(Measure.Pressure),
            def: Unit.PSI
        },
        {
            key: "energy",
            label: tr("Energy"),
            list: get_unit_list(Measure.Energy),
            def: Unit.Joule
        },
        {
            key: "adjustment",
            label: tr("Adjustment"),
            list: get_unit_list(Measure.Angular),
            def: Unit.MIL
        },
    ]


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
                    <SimpleScrollDialog title={field.label} text={UnitProps[curValue].name} onAccept={onAccept}>
                        <RadioGroup initialValue={curValue} onChange={setValue} items={field.list} />
                    </SimpleScrollDialog>
                </Col>
            </Row>
        )
    }


    return (
        <InputCard title={tr("Units of measurement")}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <UnitSelector key={field.key} field={field}/>)}
            </Grid>
        </InputCard>
    )

}