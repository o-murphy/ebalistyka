import { Appbar } from 'react-native-paper';
import { Platform } from 'react-native';

const MORE_ICON = Platform.OS === 'ios' ? 'dots-horizontal' : 'dots-vertical';


export default function TopAppBar({props}) {

    const { nightMode, toggleNightMode } = props;

    return (
        <Appbar.Header elevated={true} >
            <Appbar.Content title="Title" />
            <Appbar.Action
                icon={nightMode ? "brightness-7" : "brightness-3"}
                onPress={() => toggleNightMode(!nightMode)}
            />
            <Appbar.Action icon={MORE_ICON} onPress={() => { }} />


        </Appbar.Header>
    );

}
