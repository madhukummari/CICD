import React from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import './App.css';
import logo from './logo.svg'; // Add your logo image in the src folder

const Home = () => {
  const navigate = useNavigate();

  return (
    <div className="home">
      <header className="home-header">
        <img src={logo} alt="Madhu Stationery Logo" className="logo" />
        <h1>Madhu Stationery</h1>
      </header>
      <div className="home-content">
        <h2 className="big-title">Welcome to Madhu Stationery</h2>
        <p>Your one-stop shop for all stationery needs!</p>
        <button onClick={() => navigate('/products')}>See Products</button>
      </div>
    </div>
  );
};

const Products = () => {
  const [products, setProducts] = React.useState([]);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState(null);
  const navigate = useNavigate(); // For navigating back to Home

  React.useEffect(() => {
    fetch('http://3.87.222.252:8080/api/products')
      .then((response) => response.json())
      .then((data) => {
        console.log("Fetched products:", data); // Debugging
        setProducts(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching products:", error);
        setError(error);
        setLoading(false);
      });
  }, []);

  return (
    <div className="app">
      <header className="app-header">
        <img src={logo} alt="Madhu Stationery Logo" className="logo" />
        <h1>Madhu Stationery</h1>
      </header>

      {/* Back to Home Button */}
      <button className="back-button" onClick={() => navigate('/')}>🏠 Back to Home</button>

      <h2>Our Products</h2>
      <div className="product-list">
        {loading ? (
          <p>Loading products...</p>
        ) : error ? (
          <p>Error fetching products: {error.message}</p>
        ) : products.length === 0 ? (
          <p>No products found</p>
        ) : (
          products.map((product) => (
            <div key={product.id} className="product-card">
              <h2>{product.name}</h2>
              <p>Price: ${product.price}</p>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/products" element={<Products />} />
      </Routes>
    </Router>
  );
};

export default App;
