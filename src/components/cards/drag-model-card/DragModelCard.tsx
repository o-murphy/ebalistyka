import React, {useState} from "react";
import {InputCard} from "../index";
import {SegmentedButtons, Text, useTheme} from "react-native-paper";
import MBCTable from "./MBCTable";
import CDMTable from "./CDMTable";


export default function DragModelCard() {

    const theme = useTheme()

    const dragTypeStates = [
        {
            value: 'G7',
            label: 'G7',
            icon: null,
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        },
        {
            value: 'G1',
            label: 'G1',
            icon: null,
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        },
        {
            value: 'CDM',
            label: 'CDM',
            icon: null,
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        },
    ]

    const [dragType, setDragType] = useState("G7");


    return (
        <InputCard title={"Drag model"}>

            <SegmentedButtons
                buttons={dragTypeStates} value={dragType} onValueChange={setDragType}/>

            {
                dragType == "CDM" ?
                <CDMTable /> :
                <MBCTable dragModelType={dragType}/>
            }

        </InputCard>
    )
}