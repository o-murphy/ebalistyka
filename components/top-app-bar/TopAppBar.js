import { useState } from 'react';
import { Appbar } from 'react-native-paper';
import { Platform } from 'react-native';

const MORE_ICON = Platform.OS === 'ios' ? 'dots-horizontal' : 'dots-vertical';


export default function TopAppBar() {

    const [nightMode, setNightmode] = useState(false);

    return (
        <Appbar.Header elevated={true} >
            <Appbar.Content title="Title" />
            <Appbar.Action
                icon={nightMode ? "brightness-7" : "brightness-3"}
                onPress={() => setNightmode(!nightMode)}
            />
            <Appbar.Action icon={MORE_ICON} onPress={() => { }} />


        </Appbar.Header>
    );

}
