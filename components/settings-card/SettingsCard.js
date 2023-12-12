import { Card, Button, Text } from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"


export default function SettingsCard() {


    return (
        <Card mode="elevated" elevation={1} style={{ margin: 10, padding: 0 }}>
            <Card.Title title="Settings"
            />
            <Card.Content>
                <Text variant="bodyMedium">General</Text>
                <LanguagePicker />
            </Card.Content>
        </Card>
    )

}