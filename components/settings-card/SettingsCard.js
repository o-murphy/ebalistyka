import { Card, Button, Text } from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import UnitPicker from "../unit-picker/UnitPicker"


export default function SettingsCard() {


    return (
        <Card mode="elevated" elevation={1} style={{ margin: 10, padding: 0 }}>
            <Card.Title title="Settings"
            />
            <Card.Content style={{ margin: 10, padding: 0 }}>
                <Text style={{ marginBottom: 10 }} variant="bodyMedium">General</Text>
                <LanguagePicker style={{ flex: 1, marginBottom: 10 }} />

                <Text style={{ marginBottom: 10 }} variant="bodyMedium">Units of</Text>
                <UnitPicker style={{ flex: 1, marginBottom: 10 }} zIndex={1000} label="Distance" />
                <UnitPicker style={{ flex: 1, marginBottom: 10 }} zIndex={1000} label="Velocity" list={[{ label: "Meter per second", value: "mps", },]} />

            </Card.Content>
        </Card>
    )

}