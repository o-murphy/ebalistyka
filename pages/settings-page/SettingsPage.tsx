import { View } from 'react-native';
import ContentCard from '../../components/content-card/ContentCard';
import SettingsCard from '../../components/settings-card/SettingsCard';

export default function SettingsPage() {

    return (
        <View>
            <SettingsCard />
            <ContentCard />
        </View>
    );
}
