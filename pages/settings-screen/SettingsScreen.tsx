import {Dimensions, ScrollView} from 'react-native';
import {useTheme} from 'react-native-paper';
import ContentCard from '../../components/content-card/ContentCard';
import SettingsCard from '../../components/settings-card/SettingsCard';

export default function SettingsScreen({props}) {

    const theme = useTheme();

    const styles = {
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
            height: Dimensions.get('window').height * 0.8, // Set the height as a percentage of the screen height
            marginBottom: 80
        },
    }

    return (
        <ScrollView
            style={styles.scrollViewContainer}
            keyboardShouldPersistTaps="always"
            alwaysBounceVertical={false}
            showsVerticalScrollIndicator={true}
        >
            <SettingsCard />
            <ContentCard />
        </ScrollView>
    );
}
