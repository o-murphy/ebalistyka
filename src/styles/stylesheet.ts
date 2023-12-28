import {Dimensions} from "react-native";
import {useTheme} from "react-native-paper";

// const theme = useTheme()

const styleSheet = {
    grid: {
        grid: {
            flex: 1,
        },
        row: {
            flex: 1,
            alignItems: "center",
        },
        col: {
            flex: 1,
        },
    },
    card: {
        card: {margin: 10, padding: 5},
        content: {marginHorizontal: 0, paddingHorizontal: 10},
    },
    bottomBar: {
        backgroundColor: 'aquamarine',
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0,
    },
    fab: {
        position: 'absolute',
        right: 16
    }
}

export default styleSheet;