import { Appbar } from 'react-native-paper';
import { Platform } from 'react-native';
import { getHeaderTitle } from '@react-navigation/elements';

const MORE_ICON = Platform.OS === 'ios' ? 'dots-horizontal' : 'dots-vertical';


export default function TopAppBar({navigation, route, options, back, toggleTheme}) {
    const { nightMode, toggleNightMode } = toggleTheme;
    const title = getHeaderTitle(options, route.name);

    return (
        <Appbar.Header elevated={true} >
            {back ? <Appbar.BackAction onPress={navigation.goBack} /> : null}
            <Appbar.Content title={title} />
            <Appbar.Action
                icon={nightMode ? "brightness-7" : "brightness-3"}
                onPress={() => toggleNightMode(!nightMode)}
            />
            <Appbar.Action icon={MORE_ICON} onPress={() => { }} />


        </Appbar.Header>
    );

}
