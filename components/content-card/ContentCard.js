import { Card, Button, Text } from "react-native-paper"

export default function ContentCard() {


    return (
        <Card mode="elevated" elevation={2} style={{ margin: 10, padding: 5 }}>
            <Card.Title title="Card Title" subtitle="Card Subtitle" />
            <Card.Content>
                
                <Text variant="titleLarge">Card title</Text>
                <Text variant="bodyMedium">Card content</Text>
            </Card.Content>
            <Card.Cover mode="elevated" elevation={1} source={{ uri: 'https://picsum.photos/700' }} />
            <Card.Actions>
                <Button>Cancel</Button>
                <Button>Ok</Button>
            </Card.Actions>
        </Card>
    )

}