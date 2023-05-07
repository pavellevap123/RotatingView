//
//  ViewController.swift
//  RotatingView
//
//  Created by Pavel Paddubotski on 7.05.23.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rotatingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    private var distance: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderReleased), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderReleased), for: .touchUpOutside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        distance = containerView.bounds.width - ((rotatingView.bounds.width / 2) * 2) + (rotatingView.bounds.width / 2 * 0.5)
        rotatingView.center = CGPoint(x: rotatingView.bounds.width / 2, y: containerView.bounds.height / 2)
    }
    
    private func layout() {
        view.addSubview(containerView)
        containerView.addSubview(rotatingView)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            // containerView
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            
            // rotatingView
            rotatingView.heightAnchor.constraint(equalToConstant: 80),
            rotatingView.widthAnchor.constraint(equalTo: rotatingView.heightAnchor),
            
            // slider
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 48)
        ])
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        
        let scaleFactor = 1 + (sender.value * 0.5)
        let angle = sender.value * 90
        
        let distance = CGFloat(sender.value) * self.distance
        
        UIView.animate(withDuration: 0.2, animations: {
            if distance < self.rotatingView.bounds.width / 2 {
                self.rotatingView.center.x = self.rotatingView.bounds.width / 2
            } else {
                self.rotatingView.center.x = distance
            }
            
            self.rotatingView.transform = CGAffineTransform(rotationAngle: CGFloat(angle) * CGFloat.pi / 180).concatenating(CGAffineTransform(scaleX: CGFloat(scaleFactor), y: CGFloat(scaleFactor)))
        })
    }
    
    @objc func sliderReleased(_ sender: UISlider) {
        sender.value = 1
        sliderValueChanged(sender)
    }
}

