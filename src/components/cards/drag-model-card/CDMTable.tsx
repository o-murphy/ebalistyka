import {DataTable, Icon, Text} from 'react-native-paper';
import {Unit, UnitProps} from "js-ballistics";
import {useState} from "react";


const CDMTable = () => {

    const from = 0;
    const to = 100;

    const initialData = [
        {
            key: 0, // Creating an incremental key and value
            mach: 1,
            cd: 0.121
        }
    ];
    for (let i = from; i < to; i++) {
        const obj = {
            key: i+1, // Creating an incremental key and value
            mach: 0,
            cd: 0
        };
        initialData.push(obj);
    }

    const [items] = useState(initialData)

    return (
        <DataTable>
            <DataTable.Header>
                <DataTable.Title textStyle={{fontSize: 16}}>{`Mach`}</DataTable.Title>
                <DataTable.Title textStyle={{fontSize: 16}}>{`CD`}</DataTable.Title>
            </DataTable.Header>

            {items.slice(from, to).map((item) => (
                <DataTable.Row key={item.key}>

                    <DataTable.Cell textStyle={{fontSize: 16}}>
                        {item.mach}
                    </DataTable.Cell>
                    <DataTable.Cell textStyle={{fontSize: 16}}>
                        {item.cd}
                    </DataTable.Cell>
                </DataTable.Row>
            ))}

        </DataTable>
    );
};

export default CDMTable;