import QtQml
import Quickshell
import "./" as Root
import "components" as Components

ShellRoot {
    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property var modelData

            Root.Frame { modelData: scope.modelData }
            Components.Reservation { modelData: scope.modelData; edge: "top"; amount: Root.Theme.barHeight }
            Components.Reservation { modelData: scope.modelData; edge: "bottom"; amount: Root.Theme.frameThickness }
            Components.Reservation { modelData: scope.modelData; edge: "left"; amount: Root.Theme.frameThickness }
            Components.Reservation { modelData: scope.modelData; edge: "right"; amount: Root.Theme.frameThickness }
        }
    }
}
