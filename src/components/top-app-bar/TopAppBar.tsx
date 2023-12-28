import { Appbar } from 'react-native-paper';
import { Platform } from 'react-native';
import { getHeaderTitle } from '@react-navigation/elements';

const MORE_ICON = Platform.OS === 'ios' ? 'dots-horizontal' : 'dots-vertical';


export default function TopAppBar({...props}) {
    const {navigation, route, options, back, params} = props;
    const { nightMode, toggleNightMode } = params;
    const title = getHeaderTitle(options, route.name);
    console.log(route.name)
    return (
        <Appbar.Header elevated={true} >
            {back ? <Appbar.BackAction onPress={navigation.goBack} /> : null}
            <Appbar.Content title={title} />
            <Appbar.Action
                icon={nightMode ? "brightness-7" : "brightness-3"}
                onPress={() => toggleNightMode(!nightMode)}
            />
            {/*{route.name === "Home" ? <Appbar.Action icon='cog' onPress={() => navigation.navigate('Settings')} /> : null}*/}
            <Appbar.Action icon={MORE_ICON} onPress={() => { }} />


        </Appbar.Header>
    );

}
