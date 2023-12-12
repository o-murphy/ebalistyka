import { View } from 'react-native';
import ContentCard from '../../components/content-card/ContentCard';
import SettingsCard from '../../components/settings-card/SettingsCard';

export default function SettingsPage() {

    // const handleTextPress = () => console.log("Hello")
    // const handleBtnPress = () => Alert.alert("Btn", "Message",
    //     { text: "OK", onPress: () => console.log("OK") },
    //     { text: "Cancel", onPress: () => console.log("Cancel") },
    // )

    return (
            <View
                // contentContainerStyle={contentContainerStyle}
                keyboardShouldPersistTaps="always"
                alwaysBounceVertical={false}
                showsVerticalScrollIndicator={false}
                // style={[containerStyle, style]}
            >

                <SettingsCard  />
                <ContentCard />
                <ContentCard />

            </View>
    );
}
