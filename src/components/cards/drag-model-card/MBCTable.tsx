import {DataTable} from 'react-native-paper';
import {MeasureField} from "../../measure-slider-modal/MeasureSliderModal";
import {Unit, UnitProps} from "js-ballistics";
import {useState} from "react";
import TableValuePicker from "./TableValuePicker";


const MBCTable = ({dragModelType}) => {

    const from = 0;
    const to = 5;

    const initialData = [
        {
            key: 0, // Creating an incremental key and value
            velocity: {
                key: 0,
                label: "Velocity",
                suffix: "",
                icon: "",
                mode: "int" as const,
                initialValue: 805,
                maxValue: 2000,
                minValue: 0,
                decimals: 0,
            },
            bc: {
                key: 0,
                label: "BC 1",
                suffix: "",
                icon: null,
                mode: "float" as const,
                initialValue: dragModelType === 'G7' ? 0.381 : 0.768,  // FIXME
                maxValue: 2,
                minValue: 0,
                decimals: 3,
            }
        }
    ];
    for (let i = from; i < to; i++) {
        const obj = {
            key: i + 1, // Creating an incremental key and value
            velocity: {
                key: i + 1,
                label: "Velocity",
                suffix: "",
                icon: "",
                mode: "int" as const,
                initialValue: 0,
                maxValue: 2000,
                minValue: 0,
                decimals: 0,
            },
            bc: {
                key: i + 1,
                label: `BC ${i + 2}`,
                suffix: "",
                icon: null,
                mode: "float" as const,
                initialValue: 0,
                maxValue: 2,
                minValue: 0,
                decimals: 3,
            }
        };
        initialData.push(obj);
    }

    const [items] = useState(initialData)

    return (
        <DataTable>
            <DataTable.Header>
                <DataTable.Title textStyle={{fontSize: 16}}>{`Velocity, mps`}</DataTable.Title>
                <DataTable.Title textStyle={{fontSize: 16}}>{`BC, ${dragModelType}`}</DataTable.Title>
            </DataTable.Header>

            {items.slice(from, to).map((item) => (
                <DataTable.Row key={item.key}>

                    <DataTable.Cell>

                        <TableValuePicker key={item.key} field={item.velocity}/>

                    </DataTable.Cell>
                    <DataTable.Cell>

                        <TableValuePicker key={item.key} field={item.bc}/>

                    </DataTable.Cell>
                </DataTable.Row>
            ))}

        </DataTable>
    );
};

export default MBCTable;